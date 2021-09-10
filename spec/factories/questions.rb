# == Schema Information
#
# Table name: questions
#
#  id                :integer          not null, primary key
#  text              :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  assessment_id     :integer
#  question_group_id :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :question do
    question_group_id { 1 }
    text { Faker::Lorem.paragraph }
  end
end
