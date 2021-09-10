# == Schema Information
#
# Table name: webcast_facilitators
#
#  id            :integer          not null, primary key
#  email         :string(255)
#  access_token  :string(255)
#  organizer_key :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :webcast_facilitator do
    email { "MyString" }
    access_token { "MyString" }
    organizer_key { "MyString" }
  end
end
