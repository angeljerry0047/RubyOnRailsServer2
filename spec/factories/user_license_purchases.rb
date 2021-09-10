# == Schema Information
#
# Table name: user_license_purchases
#
#  id                 :integer          not null, primary key
#  user_id            :integer
#  organization_id    :integer
#  licenses_purchased :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  charge_id          :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :user_license_purchase do
    user_id { 1 }
    organization_id { 1 }
    lisences_purchased { 1 }
    charge_id { 1 }
  end
end
