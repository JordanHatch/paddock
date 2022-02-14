# @label Sprint navigation
class Sprints::SprintNavigationComponentPreview < ViewComponent::Preview
  # @label Default
  # ----------------
  #
  # @display bg_color "#6a8892"
  def default
    render(Sprints::SprintNavigationComponent.new(sprint: sprint,
                                                  team: team,
                                                  previous_sprint: sprint,
                                                  next_sprint: sprint,
                                                  controller_name: 'sprints',
                                                  action_name: 'show'))
  end

  private

  def sprint
    Sprint.new(id: 1, start_on: Date.today, end_on: Date.today + 2.weeks)
  end

  def team
    Team.new(id: 1)
  end
end
