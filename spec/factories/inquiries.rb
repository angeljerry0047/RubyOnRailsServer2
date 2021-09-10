# == Schema Information
#
# Table name: inquiries
#
#  id                        :integer          not null, primary key
#  title                     :string(255)
#  body                      :text
#  user_id                   :integer
#  organization_id           :integer
#  category                  :string(255)
#  best_practice_category_id :integer
#  documents                 :string(255)
#  is_public                 :boolean          default(FALSE)
#  got_point                 :boolean          default(FALSE)
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :inquiry do
    title { "MyString" }
    body { "MyText" }
    user_id { 1 }
    organization_id { 1 }
    category { "MyString" }
    best_practice_category_id { "MyString" }
    document { "MyString" }
    is_public { false }
    got_point { false }
  end
end
