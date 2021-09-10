FactoryBot.define do

  factory :mentorship_circle, :class => "MentorshipCircle" do
    title       { Faker::Lorem.words.join(" ") }
    description { Faker::Lorem.words.join(" ") }
    start_date  { 2.days.ago }
    end_date    { 10.days.from_now }
    mentor      { association :professional }
    mctype      { Faker::Lorem.words.join(" ") }
  end

end
