# == Schema Information
#
# Table name: coupons
#
#  id              :integer          not null, primary key
#  code            :string(255)
#  organization_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  limit           :integer          default(0)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :coupon do
    code { Time.now.to_s + rand.to_s }
    limit { 1 }
    association(:organization, :factory => :company)
  end
end
