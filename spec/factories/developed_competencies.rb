# == Schema Information
#
# Table name: developed_competencies
#
#  id             :integer          not null, primary key
#  competency_id  :integer
#  opportunity_id :integer
#  description    :text
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :developed_competency do
    description { "MyText" }
    competency_id { 1 }
    opportunity_id { 1 }
  end
end
