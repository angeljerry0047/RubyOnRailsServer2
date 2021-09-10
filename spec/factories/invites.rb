# == Schema Information
#
# Table name: invites
#
#  id           :integer          not null, primary key
#  oid          :string(255)
#  first_name   :string(255)
#  last_name    :string(255)
#  provider     :string(255)
#  completed_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :integer
#  email        :string(255)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :invite do
    oid { 1 }
    first_name { 'MyString' }
    last_name  { 'MyString' }
    provider   { 'linkedin' }
    email      { 'bob@somedomain.com' }
  end
end
