FactoryBot.define do

  factory :team do
    sequence(:name) {|n| "Team #{n}"}
    group
  end

end
