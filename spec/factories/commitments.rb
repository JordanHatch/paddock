FactoryBot.define do
  factory :commitment do
    sequence(:number)
    name { Faker::Lorem.words(number: 7) }
    overview { Faker::Hacker.say_something_smart }
    quarter
  end
end
