class SprintUpdates::BuildUpdateService < BaseService
  def initialize(team_id:, sprint_id:, form_class:)
    @team_id = team_id
    @sprint_id = sprint_id
    @form_class = form_class
  end

  def call
    begin
      if update.present? && form.present?
        prevalidate_form
        self.state = :success
      else
        self.state = :failure
      end
    rescue ActiveRecord::RecordNotFound
      self.state = :failure
    end
  end

  def team
    @team ||= Team.friendly.for_sprint(sprint).find(team_id)
  end

  def sprint
    @sprint ||= Sprint.find(sprint_id)
  end

  def update
    @update ||= Update.find_or_initialize_by(sprint: sprint, team: team)
  end

  def form
    @form ||= form_class.from_model(update)
  end

  private
  attr_reader :team_id, :sprint_id, :form_class

  def prevalidate_form
    form.validate if form.started?
  end
end
