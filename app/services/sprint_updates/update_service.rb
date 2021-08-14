class SprintUpdates::UpdateService < BaseService
  attr_reader :form

  def initialize(team_id:, sprint_id:, form_class:)
    @team_id = team_id
    @sprint_id = sprint_id
    @form_class = form_class
  end

  def self.build(**args)
    new(**args).tap(&:build_form)
  end

  def self.update(**args)
    new(**args.slice(:team_id, :sprint_id, :form_class))
      .tap {|s| s.persist_form(args[:attributes]) }
  end

  def build_form
    begin
      check_update_can_be_edited

      @form = form_class.from_model(update)
      prevalidate_form

      set_state(:success)
    rescue Failure
      set_state(:failure)
    end
  end

  def persist_form(attributes)
    begin
      check_update_can_be_edited

      @form = form_class.from_form(attributes)
      update.assign_attributes(form.to_model_hash)

      raise Failure unless update.save

      set_state(:success)
    rescue Failure
      set_state(:failure)
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
  attr_reader :team_id, :sprint_id, :form_class

  def check_update_can_be_edited
    begin
      raise Failure unless update.present? && update.can_be_edited?
    rescue ActiveRecord::RecordNotFound
      raise Failure
    end
  end

  def prevalidate_form
    form.validate if form.started?
  end
end
