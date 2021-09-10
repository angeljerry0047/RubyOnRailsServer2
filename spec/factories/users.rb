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

FactoryBot.define do

  factory :professional, :class => "User", :aliases => [:user] do
    name                  { Faker::Name.name }
    email                 { Faker::Internet.free_email }
    password              { 'Testtest1' }
    password_confirmation { 'Testtest1' }
  end
  
  factory :company_admin, :class => "User" do |u|
    email                 { Faker::Internet.free_email }
    password              { 'Testtest1' }
    password_confirmation { 'Testtest1' }
    u.association :managed_organization, :factory => "company"
  end
  
  factory :non_profit_admin, :class => "User" do |u|
    email                 { Faker::Internet.free_email }
    password              { 'Testtest1' }
    password_confirmation { 'Testtest1' }
    u.association :managed_organization, :factory => "non_profit"
  end
  
  factory :user_with_opportunities, :class => "User" do |u|
    email                 { Faker::Internet.free_email }
    password              { 'Testtest1' }
    password_confirmation { 'Testtest1' }
    u.opportunities {|opportunities| [opportunities.association(:opportunity)]}
  end

end
