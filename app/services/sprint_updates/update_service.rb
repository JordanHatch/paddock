class SprintUpdates::UpdateService < BaseService
  attr_reader :form

  def initialize(team_id:, sprint_id:, form_class:, attributes: {})
    @team_id = team_id
    @sprint_id = sprint_id
    @form_class = form_class
    @attributes = attributes
  end

  def build
    yield List::Validated[
             validate_update,
           ].traverse.to_result

    @form = form_class.from_model(update)
    prevalidate_form

    Success(update)
  end

  def call
    yield List::Validated[
             validate_update,
           ].traverse.to_result

    @form = form_class.from_form(attributes)
    update.assign_attributes(form.to_model_hash)

    if update.save
      Success(update)
    else
      Failure(:save_failed)
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

  private

  attr_reader :team_id, :sprint_id, :form_class, :attributes

  def validate_update
    if update.present? && update.can_be_edited?
      Valid(update)
    else
      Invalid(:update_cannot_be_edited)
    end
  end

  def prevalidate_form
    form.validate if form.started?
  end
end
