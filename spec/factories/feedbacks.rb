# == Schema Information
#
# Table name: feedbacks
#
#  id             :integer          not null, primary key
#  opportunity_id :integer
#  creator_id     :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  q1             :integer
#  q2             :integer
#  q3             :integer
#  q4             :integer
#  q5             :integer
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :feedback do
    opportunity_id { 1 }
    creator_id { 1 }
    body { "MyText" }
  end
end
