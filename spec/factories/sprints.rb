FactoryBot.define do

  BASE_START_ON = 4.weeks.ago

  factory :sprint do
    sequence(:name) {|n| "Sprint #{n}"}
    sequence(:start_on) {|n| BASE_START_ON + (n*2).weeks }
    sequence(:end_on) {|n| BASE_START_ON + (n*2+2).weeks }
  end

end
