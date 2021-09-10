# == Schema Information
#
# Table name: recommendation_applications
#
#  id                  :integer          not null, primary key
#  recommendation_id   :integer
#  user_id             :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  application_message :text
#  complete_plan       :boolean          default(FALSE)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :recommendation_application do
    recommendation_id { 1 }
    user_id { 1 }
  end
end
