FactoryBot.define do

  factory :team do
    sequence(:name) {|n| "Team #{n}"}
    start_on { BASE_START_ON }
    group
  end

end
