FactoryBot.define do
  factory :sprint do
    sequence(:name) { |n| "Sprint #{n}" }
    sequence(:short_label)
    sequence(:start_on) { |n| BASE_START_ON + (n * 2).weeks }
    sequence(:end_on) { |_n| start_on + 2.weeks }
  end
end
