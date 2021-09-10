# == Schema Information
#
# Table name: points
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  badge_type_id :integer
#  year          :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :point do
    user_id { 1 }
    type_id { 1 }
    year { 1 }
  end
end
