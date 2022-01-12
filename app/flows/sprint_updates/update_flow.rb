class SprintUpdates::UpdateFlow < BaseFlow
  def initialize(current_form_id:, sprint_update:)
    super(
      current_form_id: current_form_id,
      object: sprint_update,
    )
  end

  def forms
    {
      delivery_status: SprintUpdates::DeliveryStatusForm,
      okr_status: SprintUpdates::OkrStatusForm,
      summary: SprintUpdates::SummaryForm,
      sprint_goals: SprintUpdates::SprintGoalsForm,
      headcount: SprintUpdates::HeadcountForm,
      team_health: SprintUpdates::TeamHealthForm,
      issues: SprintUpdates::IssuesForm,
      next_sprint: SprintUpdates::NextSprintForm,
    }
  end

  private

  def default_form_id
    :delivery_status
  end
end
