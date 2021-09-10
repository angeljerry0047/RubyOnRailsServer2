# == Schema Information
#
# Table name: industries
#
#  id             :integer          not null, primary key
#  title          :string(255)
#  naics_code     :integer
#  parent_id      :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  naics_code_top :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :industry do
    title { Faker::Company.name }
    naics_code {(0..999).to_a.sample(1).first}
    parent_id { 1 }
  end
end
