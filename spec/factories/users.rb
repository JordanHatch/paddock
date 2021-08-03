FactoryBot.define do

  factory :user do
    sequence(:email) {|n|
      domain = Paddock.permitted_domains
      "user.#{n}@#{domain}"
    }
  end

end
