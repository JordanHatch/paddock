FactoryBot.define do
  factory :sprint_update, class: Update do
    sprint
    team

    factory :not_started_sprint_update do
      state { :not_started }
    end

    factory :draft_sprint_update do
      state { :draft }
    end

    factory :published_sprint_update do
      state { :published }
      delivery_status { :green }
      okr_status { :amber }
    end
  end
end
