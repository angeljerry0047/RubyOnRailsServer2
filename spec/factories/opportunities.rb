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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :opportunity do
    title           { Faker::Company.bs }
    internal        { false }
    organization_id { nil }
    industry_id     { 1 }
    owner_id        { 1 }
    start_year      { (1900..Date.today.year).to_a.sample(1).first}
    start_month     { (1..12).to_a.sample(1).first}
    end_year        { nil }
    end_month       { nil }
  end

  factory :opportunity_without_title, :class => 'Opportunity' do
    title           { nil }
    internal        { false }
    organization_id { nil }
    industry_id     { 1 }
    owner_id        { 1 }
    start_year      { (1900..Date.today.year).to_a.sample(1).first}
    start_month     { (1..12).to_a.sample(1).first}
    end_year        { nil }
    end_month       { nil }  
  end
  
  factory :internal_opportunity, :class => "Opportunity" do
    title       { Faker::Company.bs }
    internal    { true }
    association(:organization, :factory => :company)
    industry_id { 1 }
    owner_id    { 1 }
    start_year  { (1900..Date.today.year).to_a.sample(1).first}
    start_month { (1..12).to_a.sample(1).first}
    end_year    { nil }
    end_month   { nil }
  end
end
