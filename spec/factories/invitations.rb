FactoryBot.define do
  factory :invitation do
    sequence(:email) do |n|
      domain = Paddock.permitted_domains
      "user.#{n}@#{domain}"
    end
  end
end
