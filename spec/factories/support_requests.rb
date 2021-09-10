FactoryBot.define do
  factory :support_request, class: 'SupportRequest' do
    name                  { Faker::Name.name }
    email                 { Faker::Internet.free_email }
    description           { Faker::Lorem.words.join(' ') }
  end
end
