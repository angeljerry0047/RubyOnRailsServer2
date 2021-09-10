# == Schema Information
#
# Table name: best_practice_categories
#
#  id            :integer          not null, primary key
#  title         :string(255)
#  description   :text
#  public        :boolean
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  active_tab    :boolean
#  recommendable :boolean
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :best_practice_category do
    title { "MyString" }
    description { "MyText" }
    public { false }
  end
end
