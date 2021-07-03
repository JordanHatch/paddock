class SprintUpdates::PublishService < BaseService
  extend Forwardable

  def_delegators :build_service, :team, :sprint, :update

  def initialize(team_id:, sprint_id:, flow:)
    @team_id = team_id
    @sprint_id = sprint_id
    @flow = flow
  end

  def call
    begin
      raise Failure unless build_service.success?

      ActiveRecord::Base.transaction do
        publish_update
      end

      self.state = :success
    rescue Failure
      self.state = :failure
    end
  end


private
  attr_reader :team_id, :sprint_id, :flow

  def build_service
    @build_service ||= SprintUpdates::BuildPublishService.call(
      team_id: team_id,
      sprint_id: sprint_id,
      flow: flow,
    )
  end

  def publish_update
    raise Failure unless (update.publish && update.save)
  end

end
