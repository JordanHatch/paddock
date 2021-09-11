class SprintUpdates::UnpublishService < BaseService
  include Dry::Monads[:list, :result, :validated, :do]

  attr_reader :team, :sprint, :update
  attr_accessor :result

  def initialize(team_id:, sprint_id:)
    @team_id = team_id
    @sprint_id = sprint_id
  end

  def self.build(**args)
    new(**args).tap do |service|
      service.result = service.build
    end
  end

  def self.unpublish(**args)
    new(**args).tap do |service|
      service.result = service.unpublish
    end
  end

  def build
    @team, @sprint = yield List::Validated[
                             validate_team(team_id),
                             validate_sprint(sprint_id),
                           ].traverse.to_result

    @update = yield validate_update(sprint, team)

    if update.may_unpublish?
      Success(update)
    else
      Failure(List[:update_not_published])
    end
  end

  def unpublish
    yield(build)

    if update.unpublish && update.save
      Success(update)
    else
      Failure(List[:unpublish_failed])
    end
  end

  def errors
    result.failure.to_a
  end

  private

  attr_reader :team_id, :sprint_id

  def validate_team(id)
    team = Team.friendly.find(id)

    if team
      Valid(team)
    else
      Invalid(:invalid_team)
    end
  end

  def validate_sprint(id)
    sprint = Sprint.find(id)

    if sprint
      Valid(sprint)
    else
      Invalid(:invalid_sprint)
    end
  end

  def validate_update(sprint, team)
    update = Update.find_or_initialize_by(sprint_id: sprint.id, team_id: team.id)

    if update
      Valid(update)
    else
      Invalid(:invalid_update)
    end
  end
end
