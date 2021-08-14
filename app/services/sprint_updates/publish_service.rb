class SprintUpdates::PublishService < BaseService
  def initialize(team_id:, sprint_id:, flow:)
    @team_id = team_id
    @sprint_id = sprint_id
    @flow = flow
  end

  def self.build(**args)
    new(**args).tap(&:build)
  end

  def self.publish(**args)
    new(**args).tap(&:publish)
  end

  def build
    check_update_can_be_published

    set_state(:success)
  rescue Failure
    set_state(:failure)
  end

  def publish
    check_update_can_be_published
    publish_update

    set_state(:success)
  rescue Failure
    set_state(:failure)
  end

  def team
    @team ||= Team.friendly.find(team_id)
  end

  def sprint
    @sprint ||= Sprint.find(sprint_id)
  end

  def update
    @update ||= Update.find_or_initialize_by(sprint: sprint, team: team)
  end

  private

  attr_reader :team_id, :sprint_id, :flow

  def publish_update
    raise Failure unless update.publish && update.save
  end

  def check_update_can_be_published
    raise Failure unless update.present? && update.may_publish? && flow.valid?
  rescue ActiveRecord::RecordNotFound
    raise Failure
  end
end
