# == Schema Information
#
# Table name: user_answers
#
#  id                   :integer          not null, primary key
#  question_id          :integer
#  likert_response      :integer
#  user_id              :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  assessment_report_id :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :user_answer do
    question
    likert_response { rand(5)}
    user
    assessment_report_id { nil }
  end
end
