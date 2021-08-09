FactoryBot.define do

  factory :user do
    sequence(:email) {|n|
      domain = Paddock.permitted_domains
      "user.#{n}@#{domain}"
    }
    role { :user }

    factory :admin_user do
      role { :admin }
    end
  end

end
