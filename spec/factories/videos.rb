# == Schema Information
#
# Table name: videos
#
#  id                      :integer          not null, primary key
#  title                   :string(255)
#  internal                :boolean
#  description             :text
#  embed_code              :text
#  competency_ids          :integer
#  category                :integer
#  learning_objectives     :string(255)
#  opportunity_category_id :integer
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :video do
    title { "MyString" }
    internal { false }
    description { "MyText" }
    embed_code { "MyString" }
    competency_ids { 1 }
    category { "" }
    learning_objectives { "MyString" }
    opportunity_category_id { 1 }
  end
end
