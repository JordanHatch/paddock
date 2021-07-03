FactoryBot.define do

  factory :invitation do
    sequence(:email) {|n| "user.#{n}@awe.gov.au" }
  end

end
