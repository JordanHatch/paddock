FactoryBot.define do
  factory :issue do
    description { Faker::Hacker.say_something_smart }
    treatment { Faker::Hacker.say_something_smart }
    help { Faker::Hacker.say_something_smart }
    identifier { Faker::Alphanumeric.alpha(number: 10) }

    sprint_update

    factory :draft_issue do
      sprint_update factory: :draft_sprint_update
    end

    factory :published_issue do
      sprint_update factory: :published_sprint_update
    end
  end
end
