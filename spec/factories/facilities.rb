FactoryBot.define do

  factory :facility, class: "Facility" do |facility|
    name { Faker::Name.name }
  end
end
