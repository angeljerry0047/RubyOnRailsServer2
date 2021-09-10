# == Schema Information
#
# Table name: opportunities
#
#  id                        :integer          not null, primary key
#  title                     :string(255)
#  internal                  :boolean
#  organization_id           :integer
#  industry_id               :integer
#  start_year                :integer
#  start_month               :integer
#  end_year                  :integer
#  end_month                 :integer
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  min_hour                  :integer
#  max_hour                  :integer
#  description               :text
#  quantity                  :integer
#  city                      :string(255)
#  state                     :string(255)
#  department                :string(255)
#  owner_id                  :integer
#  learning_objectives       :text
#  start_date                :datetime
#  deadline_date             :datetime
#  start_time                :string(255)
#  end_time                  :string(255)
#  max_students              :integer
#  min_students              :integer
#  facility_id               :integer
#  opportunity_category_id   :integer
#  approval_status           :boolean          default(FALSE)
#  approval_code             :string(255)
#  opportunity_type_id       :integer
#  webcast_id                :string(255)
#  webcast_facilitator_id    :string(255)
#  online_info               :text
#  best_practice_category_id :integer
#  meeting_time              :string(255)
#  location                  :text
#  lonlat                    :spatial          point, 4326
#

# FIXME (cmhobbs+mbindya) make an effort to make these specs human 
#       readable.  consolidate into context blocks were necessary
require 'spec_helper'

describe Opportunity do
  let (:opportunity) { FactoryBot.create(:opportunity) }
  
  # FIXME (cmhobbs) i don't even.
  it 'external? is just not internal?' do
    opportunity.internal = true
    opportunity.should_not be_external
  end
  
  context 'validations' do
    
    let(:opportunity_without_title) do
      FactoryBot.build(:opportunity_without_title)
    end

    let(:dated_opportunity) { FactoryBot.build(:opportunity) }

    #it 'validates the presence of title' do
      # NOTE (cmhobbs+mbindya) this can be accomplished more efficiently
      #      with the valid? method.
    #  opportunity_without_title.save
    #  messages = opportunity_without_title.errors.messages.fetch(:title)
    #  expect(messages).to include("can't be blank")
    #end

    it 'validates the numericality range of start_year' do
      dated_opportunity.start_year = 1888
      dated_opportunity.valid?
      messages = dated_opportunity.errors.messages.fetch(:start_year)
      expect(messages).to include("must be greater than 1899")
    end

    skip 'validates the numericality range of end_year'
    skip 'validates the numericality range of start_month'
    skip 'validates the numericality range of end_month'

    # FIXME (cmhobbs+mbindya) condense to a single assertion and use
    #       rspec 3 syntax
    skip 'constrains years to 1900 - Current Year' do
      opportunity.start_year = 1899
      opportunity.should_not be_valid
      opportunity.start_year = Date.today.year + 2
      opportunity.should_not be_valid
      opportunity.start_year = Date.today.year
      opportunity.should be_valid
    end
    
    # FIXME (cmhobbs+mbindya) condense to a single assertion and use
    #       rspec 3 syntax
    skip 'constrains months from 1 - 12' do
      opportunity.start_month = 0
      opportunity.should_not be_valid
      opportunity.start_month = 13
      opportunity.should_not be_valid
      opportunity.start_month = 1
      opportunity.should be_valid
    end
  
  end

  context 'callbacks' do

    describe 'user notifications' do

      before do
        allow_any_instance_of(Opportunity).to receive(:not_owned).and_return(false)
        allow_any_instance_of(Opportunity).to receive(:notify_approver)
        allow_any_instance_of(Opportunity).to receive(:award_teacher_point)
      end
      
      it 'calls OpportunityWorker on create' do
        expect_any_instance_of(Opportunity).to receive(:notify_users)
        FactoryBot.create(:opportunity)
      end
      
    end
      
  end
  
  context 'internal' do
    # NOTE (cmhobbs+mbindya) makring skip until authentication is fixed
    #      in tests
    #
    # FIXME (cmhobbs+mbindya) update assertion syntax to expect
    skip 'be related to an organization if it is internal (other wise it might get lost)' do
      opportunity.organization = FactoryBot.create(:company)
      opportunity.should be_valid
    end
  end
  
  it 'returns opportunities with a competency' do
    comp = FactoryBot.create(:competency)
    comp2 = FactoryBot.create(:competency)
    
    opportunity = FactoryBot.create(:opportunity)
    opportunity.competencies << comp
    opportunity.save
    
    Opportunity.with_competencies(comp).should == [opportunity]
    Opportunity.with_competencies(comp2).should == []
    
  end
  
  context 'geospatial searching' do
    ({'lfp' => 98155, 'downtown' => 98101, 'gigharbor' => 98335}).each do |k,v|
      let(k) do
        VCR.use_cassette("#{k}_zip") do
          FactoryBot.create(:zip, :code => v)
        end
      end
    end
    
    let(:lfp_opportunity) do 
      VCR.use_cassette(:lfp_opportunity) do
        FactoryBot.create(:opportunity, :city => "Lake Forest Park", :state => "WA")
      end
    end

    # XXX (cmhobbs) deprecated with the removal of the Zip model
    pending 'doesnt return stuff obviously out of bounds' do
      Opportunity.within(gigharbor.code, 30).should == []
    end
  end
  
  skip 'uses a standard industry classification database'
  
  context 'permissions' do
    let(:private_opportunity) { FactoryBot.create(:internal_opportunity) }
    let(:public_opportunity) { FactoryBot.create(:opportunity) }
    
    # NOTE (cmhobbs+mbindya) makring skip until authentication is fixed
    #      in tests
    #
    # FIXME (cmhobbs+mbindya) update assertion syntax to expect
    # FIXME (cmhobbs+mbindya) condense test to a single assertion
    skip 'can only be seen by users within the same organization if private' do
      user_can_see = FactoryBot.create(:professional)
      user_can_see.managed_organization = private_opportunity.organization
      user_can_see.save!  
      
      user_can_not_see = FactoryBot.create(:professional)
        
      see_ability = Ability.new(user_can_see)
      no_ability  = Ability.new(user_can_not_see)
      
      see_ability.should be_able_to(:read, private_opportunity)
      no_ability.should_not be_able_to(:read, private_opportunity)
    end
    
    # NOTE (cmhobbs+mbindya) makring skip until authentication is fixed
    #      in tests
    #
    # FIXME (cmhobbs+mbindya) update assertion syntax to expect
    skip 'can be seen by everybody if the opportunity is public' do
      user    = FactoryBot.create(:professional)
      ability = Ability.new(user)
      
      ability.should be_able_to(:read, public_opportunity)
    end
  end
  
  context 'time commitment per week' do
    let (:opportunity) { FactoryBot.create(:opportunity, :min_hour => 10, :max_hour => 40) }
    
    it 'will display :min_hour - :max_hour per week' do
      opportunity.weekly_commitment.should == [opportunity.min_hour, opportunity.max_hour].join(' - ') + ' hours per week'
    end
    
    it 'will display less than :max_hour if :min_hour is blank' do
      opportunity.min_hour = nil
      opportunity.weekly_commitment.should == "Less than #{opportunity.max_hour} hours per week"
    end
    
    it 'will display :min_hour + if the max_hour is blank' do
      opportunity.max_hour = nil
      opportunity.weekly_commitment.should == "More than #{opportunity.min_hour} hours per week"
    end
    
    it 'will display a no time commitment message when there is not a time commitment' do
      opportunity.max_hour = nil
      opportunity.min_hour = nil
      opportunity.weekly_commitment.should == "No time commitment"
    end
  
  end

end
