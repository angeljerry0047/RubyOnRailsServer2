# == Schema Information
#
# Table name: testimonials
#
#  id             :integer          not null, primary key
#  opportunity_id :integer
#  creator_id     :integer
#  approved       :boolean
#  body           :text
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :testimonial do
    opportunity_id { 1 }
    creator_id { 1 }
    approved { false }
    body { "MyText" }
  end
end
