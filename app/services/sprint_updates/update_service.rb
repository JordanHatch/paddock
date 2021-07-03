class SprintUpdates::UpdateService < BaseService
  extend Forwardable

  def_delegators :build_service, :team, :sprint, :update

  def initialize(team_id:, sprint_id:, form_class:, attributes:)
    @team_id = team_id
    @sprint_id = sprint_id
    @form_class = form_class
    @attributes = attributes.dup.permit!
  end

  def call
    begin
      raise Failure unless build_service.success?

      ActiveRecord::Base.transaction do
        persist_form
      end

      self.state = :success
    rescue Failure
      self.state = :failure
    end
  end

  def form
    @form ||= form_class.from_form(attributes)
  end

private
  attr_reader :team_id, :sprint_id, :form_class, :attributes

  def build_service
    @build_service ||= SprintUpdates::BuildUpdateService.call(
      team_id: team_id,
      sprint_id: sprint_id,
      form_class: form_class,
    )
  end

  def persist_form
    update.assign_attributes(form.to_model_hash)
    raise Failure unless update.save
  end

end
