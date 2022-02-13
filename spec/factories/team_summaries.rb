FactoryBot.define do
  factory :team_summary do
    team
    sprint
    sprint_update

    id { team.id }
    sprint_id { sprint.id }
    update_id { sprint_update.id }

    name { team.name }
    start_on { team.start_on }
    slug { team.slug }
    group_id { team.group_id }

    state { sprint_update.state }
    delivery_status { sprint_update.delivery_status }
    okr_status { sprint_update.okr_status }
    issue_count { sprint_update.issues.count }
  end
end
