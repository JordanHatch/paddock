FactoryBot.define do
  factory :commitment do
    sequence(:number)
    name { Faker::Lorem.words(number: 7) }
    overview { Faker::Hacker.say_something_smart }
    key_commitment { false }

    group
    quarter

    factory :key_commitment do
      key_commitment { true }
    end
  end
end
