# @label Update preview
class Sprints::UpdatePreviewComponentPreview < ViewComponent::Preview
  # @label Default
  # ----------------
  #
  def default
    render Sprints::UpdatePreviewComponent.new(team_summary: team_summary)
  end

  private

  def team_summary
    FactoryBot.build(:team_summary,
                     team: FactoryBot.build(:team, id: 1, name: 'Example'),
                     sprint: FactoryBot.build(:sprint, id: 1),
                     sprint_update: FactoryBot.build(:published_sprint_update),
                     issue_count: 3)
  end
end
