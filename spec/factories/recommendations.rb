# == Schema Information
#
# Table name: recommendations
#
#  id                      :integer          not null, primary key
#  creator_id              :integer
#  user_id                 :integer
#  approval_status         :boolean
#  opportunity_category_id :integer
#  con_strength            :string(255)
#  con_engagement          :string(255)
#  con_length              :string(255)
#  con_type                :string(255)
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  internal                :boolean
#  end_year                :integer
#  end_month               :integer
#  con_performance         :string(255)
#  rec_type                :string(255)
#  con_text                :text
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :recommendation do
    id { 1 }
    creator_id { 1 }
    user_id { 1 }
    approval_status { false }
    recommendation_category_id { 1 }
    con_strength { "MyString" }
    con_engagement { "MyString" }
    con_length { "MyString" }
    con_type { "MyString" }
  end
end
