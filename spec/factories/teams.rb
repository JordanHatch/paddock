FactoryBot.define do
  factory :team do
    sequence(:name) { |n| "Team #{n}" }
    start_on { BASE_START_ON }
    end_on { nil }
    group
  end
end
