# == Schema Information
#
# Table name: applications
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  position_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :application do
    user_id { 1 }
    position_id { 1 }
  end
end
