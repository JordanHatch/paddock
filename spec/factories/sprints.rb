FactoryBot.define do

  factory :sprint do
    sequence(:name) {|n| "Sprint #{n}"}
    sequence(:start_on) {|n| BASE_START_ON + (n*2).weeks }
    sequence(:end_on) {|n| start_on + 2.weeks }
  end

end
