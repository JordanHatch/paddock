class Sprints::SprintNavigationComponent < BaseComponent
  option :sprint
  option :team

  option :previous_sprint
  option :next_sprint

  option :controller_name, type: proc(&:to_s)
  option :action_name, type: proc(&:to_s)

  private

  def link_to_previous_sprint?
    if team
      previous_sprint_exists? && team_active_in_previous_sprint?
    else
      previous_sprint_exists?
    end
  end

  def link_to_next_sprint?
    if team
      next_sprint_exists? && team_active_in_next_sprint?
    else
      next_sprint_exists?
    end
  end

  def sprint_start_on
    sprint.start_on.strftime('%b %e')
  end

  def sprint_end_on
    sprint.end_on.strftime('%b %e %Y')
  end

  def next_sprint_link
    sprint_navigation_path(next_sprint)
  end

  def previous_sprint_link
    sprint_navigation_path(previous_sprint)
  end

  def previous_sprint_exists?
    previous_sprint.present?
  end

  def next_sprint_exists?
    next_sprint.present?
  end

  def team_active_in_previous_sprint?
    team.active_in_sprint?(previous_sprint)
  end

  def team_active_in_next_sprint?
    team.active_in_sprint?(next_sprint)
  end

  def sprint_navigation_path(sprint)
    if controller_name == 'updates'
      update_path(sprint, team)
    elsif controller_name == 'sprints' && action_name == 'issues'
      sprint_issues_path(sprint)
    else
      sprint_path(sprint)
    end
  end
end
