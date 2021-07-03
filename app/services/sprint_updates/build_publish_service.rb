class SprintUpdates::BuildPublishService < BaseService
  def initialize(team_id:, sprint_id:, flow:)
    @team_id = team_id
    @sprint_id = sprint_id
    @flow = flow
  end

  def call
    if update.present? && update.may_publish? && flow.valid?
      self.state = :success
    else
      self.state = :failure
    end
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
end
