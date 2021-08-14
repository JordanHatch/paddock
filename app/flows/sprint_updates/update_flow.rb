class SprintUpdates::UpdateFlow
  attr_reader :current_form_id

  class FormNotFound < StandardError; end

  FORMS = {
    delivery_status: SprintUpdates::DeliveryStatusForm,
    okr_status: SprintUpdates::OkrStatusForm,
    summary: SprintUpdates::SummaryForm,
    sprint_goals: SprintUpdates::SprintGoalsForm,
    headcount: SprintUpdates::HeadcountForm,
    team_health: SprintUpdates::TeamHealthForm,
    issues: SprintUpdates::IssuesForm,
    next_sprint: SprintUpdates::NextSprintForm,
  }.freeze

  def initialize(current_form_id:, sprint_update:)
    @current_form_id = format_form_id(
      current_form_id || default_form_id,
    )
    @sprint_update = sprint_update
  end

  def form_keys
    FORMS.keys
  end

  def form_class
    if FORMS.key?(current_form_id)
      FORMS[current_form_id]
    else
      (raise FormNotFound, "Form \"#{current_form_id}\" not found")
    end
  end

  def next_form_id
    return nil if last_form?

    keys = FORMS.keys
    i = keys.index(current_form_id) + 1

    keys[i]
  end

  def last_form?
    current_form_id == FORMS.keys.last
  end

  def completion_status_for_form(id)
    form_status[id][:completion]
  end

  def valid?
    form_status.all? { |_, status| status[:validation] == :valid }
  end

  private

  attr_reader :sprint_update

  def form_status
    @form_status ||= FORMS.transform_values do |klass|
      klass.from_model(sprint_update).status
    end
  end

  def default_form_id
    :delivery_status
  end

  def format_form_id(id)
    id.to_sym
  end
end
