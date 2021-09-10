# == Schema Information
#
# Table name: best_practices
#
#  id                        :integer          not null, primary key
#  user_id                   :integer
#  title                     :string(255)
#  body                      :text
#  created_at                :datetime         not null
#  updated_at                :datetime         not null
#  category                  :string(255)
#  emb_link                  :text
#  ext_link                  :text
#  documents                 :string(255)
#  audio                     :string(255)
#  link_title                :string(255)
#  idea_help                 :text
#  best_practice_category_id :integer
#  organization_id           :integer
#  is_public                 :boolean
#  got_point                 :boolean          default(FALSE)
#  anonymous                 :boolean
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :best_practice do
    user_id { 1 }
    title { "MyString" }
    body { "MyText" }
  end
end
