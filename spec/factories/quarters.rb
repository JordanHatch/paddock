FactoryBot.define do
  factory :quarter do
    sequence(:name) { |n| "2021-22 Q#{n}" }
    sequence(:start_on) { |n| BASE_START_ON + (n * 3).months }
    sequence(:end_on) { |_n| start_on + 3.months }
    editable { true }

    factory :non_editable_quarter do
      editable { false }
    end
  end
end
