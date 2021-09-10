# == Schema Information
#
# Table name: coupon_uses
#
#  id                   :integer          not null, primary key
#  coupon_id            :integer
#  user_id              :integer
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  assessment_report_id :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :coupon_use do
    user_id { 1 }
  end
end
