SELECT
  t.id,
  s.id AS sprint_id,
  u.id AS update_id,
  t.name,
  t.start_on,
  t.slug,
  t.group_id,
  u.state,
  u.delivery_status,
  u.okr_status,
  (select count(*) from issues i where i.update_id = u.id) as issue_count

FROM sprints s

JOIN teams t
  ON (t.start_on <= s.end_on OR t.start_on IS NULL)

LEFT JOIN updates u
  ON (u.sprint_id = s.id AND u.team_id = t.id)
