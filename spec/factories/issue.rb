FactoryBot.define do
  factory :issue do
    description { Faker::Hacker.say_something_smart }
    treatment { Faker::Hacker.say_something_smart }
    help { Faker::Hacker.say_something_smart }
    identifier { Faker::Alphanumeric.alpha(number: 10) }

    sprint_update
  end
end
