json.partial! 'results', scope: @teams

json.results @teams do |team|
  json.partial! 'team', team: team
end
