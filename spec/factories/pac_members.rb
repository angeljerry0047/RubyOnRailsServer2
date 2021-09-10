# == Schema Information
#
# Table name: pac_members
#
#  id         :integer          not null, primary key
#  member_id  :integer
#  pac_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  approved   :boolean
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :pac_member do
    member_id { 1 }
    pac_id { 1 }
  end
end
