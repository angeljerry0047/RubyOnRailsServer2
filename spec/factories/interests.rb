# == Schema Information
#
# Table name: interests
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  parent_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :interest do
    name { "MyString" }
    parent_id { 1 }
  end
end
