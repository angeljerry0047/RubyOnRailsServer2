# == Schema Information
#
# Table name: competencies
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  parent_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  description :text
#

FactoryBot.define do
  factory :competency do
    name { Faker::Company.bs }
  end
end
