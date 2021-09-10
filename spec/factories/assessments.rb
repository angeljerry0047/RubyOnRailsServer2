# == Schema Information
#
# Table name: assessments
#
#  id          :integer          not null, primary key
#  title       :string(255)
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  price       :decimal(, )
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :assessment do
    title { "MyString" }
    description { "MyText" }
    after(:create) do |ass|
      ass.question_groups << FactoryBot.create(:question_group)
    end
  end
end
