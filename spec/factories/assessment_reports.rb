# == Schema Information
#
# Table name: assessment_reports
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  state         :string(255)
#  assessment_id :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :assessment_report do
    user
    state { "not_complete" }
    association(:assessment)
  end
end
