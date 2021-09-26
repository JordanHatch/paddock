json.partial! 'results', scope: @sprints

json.results @sprints do |sprint|
  json.partial! 'sprint', sprint: sprint
end
