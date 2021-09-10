# == Schema Information
#
# Table name: assessment_purchases
#
#  id                   :integer          not null, primary key
#  assessment_report_id :integer
#  assessment_id        :integer
#  charge_id            :string(255)
#  user_id              :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :assessment_purchase do
    assessment_report_id { nil }
    assessment_id { 1 }
    charge_id { "MyString" }
    user_id { 1 }
  end
end
