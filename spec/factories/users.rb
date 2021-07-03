FactoryBot.define do

  factory :user do
    sequence(:email) {|n| "user.#{n}@awe.gov.au" }
  end

end
