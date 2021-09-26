json.id sprint_update.id
json.url update_url(sprint_update.sprint, sprint_update.team)

json.group do
  json.id sprint_update.group.id
  json.name sprint_update.group.name
end

json.team do
  json.id sprint_update.team.id
  json.api_url api_v1_team_url(sprint_update.team.id)
  json.name sprint_update.team.name
  json.slug sprint_update.team.friendly_id
end

json.sprint do
  json.id sprint_update.sprint.id
  json.api_url api_v1_sprint_url(sprint_update.sprint.id)
  json.url sprint_url(sprint_update.sprint)
  json.name sprint_update.sprint.name
  json.start_on sprint_update.sprint.start_on
  json.end_on sprint_update.sprint.end_on
end

json.delivery_status do
  json.value sprint_update.delivery_status
  json.label sprint_update.delivery_status_text
end

json.okr_status do
  json.value sprint_update.okr_status
  json.label sprint_update.okr_status_text
end

json.team_health do
  json.value sprint_update.team_health
  json.label "#{sprint_update.team_health} / 5"
end

json.headcount do
  json.current_headcount sprint_update.current_headcount
  json.total_headcount sprint_update.total_headcount
  json.label "#{sprint_update.current_headcount} / #{sprint_update.total_headcount}"
end

json.summary do
  json.markdown sprint_update.content
  json.html render_markdown(sprint_update.content || '')
end

json.sprint_goals sprint_update.sprint_goals
json.next_sprint_goals sprint_update.next_sprint_goals

json.issues sprint_update.issues do |issue|
  json.id issue.id
  json.description issue.description
  json.treatment issue.treatment
  json.help issue.help
  json.devops_id issue.identifier
end
