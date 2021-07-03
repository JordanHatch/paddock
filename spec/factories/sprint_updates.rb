FactoryBot.define do

  factory :sprint_update, class: Update do
    sprint
    team

    factory :draft_sprint_update do
      state { :draft }
    end

    factory :published_sprint_update do
      state { :published }
    end
  end

end
