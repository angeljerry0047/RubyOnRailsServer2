# == Schema Information
#
# Table name: question_groups
#
#  id            :integer          not null, primary key
#  name          :string(255)
#  description   :text
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  assessment_id :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :question_group do
    name { %w[leadership influence meep moop].sample }
    description { "MyText" }
  end
end
