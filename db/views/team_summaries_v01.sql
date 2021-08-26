SELECT
  DISTINCT ON (t.id, sprint_id)
  t.id,
  t.name,
  t.slug,
  t.group_id,
  t.start_on,
  u.delivery_status as delivery_status,
  u.okr_status as okr_status,
  u.state as state,
  u.id as update_id,
  s.id as sprint_id,
  (select count(*) from issues i where i.update_id = u.id) as issue_count
FROM sprints s, teams t

LEFT OUTER JOIN updates u
  ON u.team_id = t.id AND u.sprint_id = sprint_id

WHERE (t.start_on <= s.end_on OR t.start_on IS NULL)
