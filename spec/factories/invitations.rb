FactoryBot.define do

  factory :invitation do
    sequence(:email) {|n|
      domain = Paddock.permitted_domains
      "user.#{n}@#{domain}"
    }
  end

end
