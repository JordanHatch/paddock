json.partial! 'results', scope: @sprint_updates

json.results @sprint_updates do |sprint_update|
  json.partial! 'sprint_update', sprint_update: sprint_update
end
