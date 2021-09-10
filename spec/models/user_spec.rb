# == Schema Information
#
# Table name: users
#
#  id                      :integer          not null, primary key
#  email                   :string(255)      default(""), not null
#  encrypted_password      :string(255)      default("")
#  reset_password_token    :string(255)
#  reset_password_sent_at  :datetime
#  remember_created_at     :datetime
#  sign_in_count           :integer          default(0)
#  current_sign_in_at      :datetime
#  last_sign_in_at         :datetime
#  current_sign_in_ip      :string(255)
#  last_sign_in_ip         :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  managed_organization_id :integer
#  name                    :string(255)
#  provider                :string(255)
#  uid                     :string(255)
#  location                :string(255)
#  description             :text
#  headline                :string(255)
#  industry                :string(255)
#  organization_id         :integer
#  access_key              :string(255)
#  access_secret           :string(255)
#  avatar                  :string(255)
#  role                    :string(255)      default("member"), not null
#  interest_ids            :integer
#  instance_url            :string(255)
#  refresh_token           :string(255)
#  old_salesforce_id       :string(255)
#  encrypted_salesforce_id :string(255)
#  encrypted_access_key    :string(255)
#  encrypted_uid           :string(255)
#  active_license          :boolean
#  licensed_date           :date
#  mute_notifications      :boolean          default(FALSE)
#  invitation_token        :string(255)
#  invitation_sent_at      :datetime
#  invitation_accepted_at  :datetime
#  invitation_limit        :integer
#  invited_by_id           :integer
#  invited_by_type         :string(255)
#  invitation_created_at   :datetime
#  via_shopify             :boolean
#  hub_member              :boolean
#

require 'spec_helper'

describe User do
  context 'Roles and permissions' do
    it 'is a professional if there is no permission to manage companies or non profits' do
      user = FactoryBot.create(:professional)
      user.managed_organization = nil
      user.should_not be_company_admin
      user.should_not be_non_profit_admin
    end

    %w[non_profit company].each do |type|
      it "is a #{type} admin if the user has a permission to manage non profits" do
        user = FactoryBot.create(:professional)
        user.managed_organization = FactoryBot.create(type)
        user.send(type == 'non_profit' ? :should : :should_not, be_non_profit_admin)
        user.send(type == 'company' ? :should : :should_not, be_company_admin)
      end
    end

    it 'is a company admin if the user has permission to manage companies' do
      user = FactoryBot.create(:professional)
      user.managed_organization = FactoryBot.create(:company)
      user.should be_company_admin
      user.should_not be_non_profit_admin
    end
  end

  context 'owned_opportunities' do
    let(:user) { FactoryBot.create(:user) }
    context 'past_opportunities' do
      it 'is past if end_year is less than current year' do
        @opp = FactoryBot.create(:opportunity, owner_id: user.id, end_year: Time.now.year - 1, end_month: 11)
        FactoryBot.create(:opportunity, owner_id: user.id, end_year: Time.now.year, end_month: 12)
        user.past_opportunities.should == [@opp]
      end

      it 'is past if end_year is current and month is less than now' do
        @opp = FactoryBot.create(:opportunity, owner_id: user.id, end_year: Time.now.year, end_month: 11)
        FactoryBot.create(:opportunity, owner_id: user.id, end_year: Time.now.year, end_month: 12)
        user.past_opportunities.should == [@opp]
      end
    end

    context 'current_opportunities' do
      it 'returns any opportunity owned by user and null on end_year or end_month' do
        FactoryBot.create(:opportunity, owner_id: user.id, end_year: Time.now.year - 1, end_month: 12)
        @opp = FactoryBot.create(:opportunity, owner_id: user.id, end_year: nil)
        user.current_opportunities.should == [@opp]
      end

      it 'returns any opportunity owned by user and greater than or equal to current month year' do
        now = Time.now
        FactoryBot.create(:opportunity, owner_id: user.id, end_year: Time.now.year - 1, end_month: 12)
        @opp = FactoryBot.create(:opportunity, owner_id: user.id, end_year: now.year, end_month: now.month)
        user.current_opportunities.should == [@opp]
      end
    end
  end

  context 'abilities' do
    %w[company non_profit].each do |role|
      it "manages a #{role} if #{role}_admin?" do
        admin = FactoryBot.create("#{role}_admin")
        ability = Ability.new(admin)
        ability.should be_able_to(:manage, admin.managed_organization)
      end
    end

    it 'cannot destroy or manage someone else' do
      user1 = FactoryBot.create(:professional)
      user2 = FactoryBot.create(:professional)

      user1_ability = Ability.new(user1)

      user1_ability.should_not be_able_to(:manage, user2)
      user1_ability.should_not be_able_to(:destroy, user2)
    end

    it 'can manage itself' do
      user = FactoryBot.create(:professional)
      ability = Ability.new(user)
      ability.should be_able_to(%i[manage destroy], user)
    end

    it 'cannot destroy or manage someone else even if company / non-profit admin' do
      company_admin = FactoryBot.create(:company_admin)
      non_profit_admin = FactoryBot.create(:non_profit_admin)
      user = FactoryBot.create(:professional)

      abilities = [Ability.new(company_admin), Ability.new(non_profit_admin)]

      abilities.each do |ability|
        ability.should_not be_able_to(:manage, user)
        ability.should_not be_able_to(:destroy, user)
      end
    end

    it 'can manage organization if group admin' do
      user = FactoryBot.create(:professional)
      organization = FactoryBot.create(:org_with_users)
      GroupAdmin.create(group_id: organization.id, admin_id: user.id)

      ability = Ability.new(user)
      assert ability.can?(:manage, organization)
    end

    it 'cannot manage organization if not group admin' do
      user = FactoryBot.create(:professional)
      organization = FactoryBot.create(:org_with_users)

      ability = Ability.new(user)
      assert ability.cannot?(:manage, organization)
    end
  end

  context 'has_child?(child)' do
    it 'should return true if it has a child' do
      competencies = FactoryBot.create_list(:competency, 2)

      user = FactoryBot.create(:professional)
      user.competencies = competencies

      user.has_child?(FactoryBot.create(:competency)).should be_falsey

      user.competencies.each do |child|
        user.has_child?(child).should be_truthy
      end
    end
  end

  it 'has opportunities associated with it' do
    u = FactoryBot.create(:professional)
    u.opportunities.should be_empty
    u.opportunities << FactoryBot.create(:opportunity)
    u.opportunities.should_not be_empty
  end

  describe '#related_users_groups' do
    let(:organization) { Organization.create(title: Faker::Company.name) }

    let(:user0) do
      User.create(
        name: Faker::Name.name,
        email: Faker::Internet.free_email,
        password: 'Testtest1',
        password_confirmation: 'Testtest1'
      )
    end

    let(:user1) do
      User.create(
        name: Faker::Name.name,
        email: Faker::Internet.free_email,
        password: 'Testtest1',
        password_confirmation: 'Testtest1'
      )
    end

    before do
      organization.users << user0
      organization.users << user1
    end

    it 'returns an array of all users in associated groups' do
      expect(user0.related_groups_users.count).to be(1)
    end
  end

  describe '#award_badge' do
    let(:user)       { FactoryBot.create(:professional) }
    let(:badge_type) { BadgeType.create(name: 'Collaborator') }

    let(:fake_notifier) { double('notifier', new_badge_email: fake_message) }
    let(:fake_message)  { double(Mail::Message, deliver!: nil) }

    before do
      Notifier.stub(:delay) { fake_notifier }
    end

    context 'given the user does not have a badge of that type' do
      it 'associates a new badge with the user' do
        user.award_badge(badge_type.id)
        expect(user.badges.count).to eq(1)
      end

      pending 'delivers an email to the user' do
        expect(fake_message).to receive(:deliver!).once
        user.award_badge(badge_type.id)
      end
    end

    context 'given the user already has a badge of that type' do
      before do
        Badge.create(user_id: user.id, badge_type_id: badge_type.id, year: Time.now.year - 1)
        user.award_badge(badge_type.id)
      end

      it 'does not associate the badge with the user' do
        expect(user.badges.count).to eq(1)
      end
    end
  end

  describe '#all_groups' do
    pending 'includes all UserGroups and the Organization'
  end
end
