# == Schema Information
#
# Table name: badge_types
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  image_url       :string(255)
#  certificate_url :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  points          :integer
#  points_req      :integer
#  awardable       :boolean
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :badge_type do
    name { "Collaborator" }
    image_url { "collaborator" }
    certificate_url { "example.org/cert" }
  end
end
