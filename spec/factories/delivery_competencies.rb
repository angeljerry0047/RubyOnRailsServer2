# == Schema Information
#
# Table name: delivery_competencies
#
#  id                      :integer          not null, primary key
#  opportunity_category_id :integer
#  competency_id           :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :delivery_competency do
    opportunity_category_id { 1 }
    competency_id { 1 }
  end
end
