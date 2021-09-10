# == Schema Information
#
# Table name: zips
#
#  id         :integer          not null, primary key
#  code       :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  lonlat     :spatial          point, 4326
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :zip do
    code { 1 }
    lonlat { "" }
  end
end
