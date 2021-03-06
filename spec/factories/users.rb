FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    sequence(:email) do |n|
      domain = Paddock.permitted_domains
      "user.#{n}@#{domain}"
    end
    role { :user }

    factory :admin_user do
      role { :admin }
    end
  end
end
