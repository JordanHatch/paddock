class SprintUpdates::PublishService < BaseService
  def initialize(team_id:, sprint_id:, flow:)
    @team_id = team_id
    @sprint_id = sprint_id
    @flow = flow
  end

  def self.publish(**args)
    new(**args).tap do |service|
      service.result = service.publish
    end
  end

  def build
    yield List::Validated[
            validate_update,
            validate_flow
          ].traverse.to_result

    Success(update)
  end

  def call
    yield build
    yield publish_update

    Success(update)
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
    if update.publish && update.save
      Success(update)
    else
      Failure(:save_failed)
    end
  end

  def validate_update
    if update.present? && update.may_publish?
      Valid(update)
    else
      Invalid(:invalid_state)
    end
  end

  def validate_flow
    if flow.valid?
      Valid(flow)
    else
      Invalid(:flow_not_valid)
    end
  end
end
