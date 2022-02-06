class Manage::SprintUpdatesController < Manage::BaseController
  def show
    @service = Sprints::UnpublishSprintUpdate.new(update: update)
  end

  def unpublish
    @service = Sprints::UnpublishSprintUpdate.run(update: update)

    if service.valid?
      flash.notice = I18n.t(:success, scope: %w[services sprint_updates unpublish])
      redirect_to update_path(sprint, team)
    else
      flash.alert = service.errors.map { |error|
        I18n.t(error, scope: %w[services sprint_updates unpublish])
      }.join(', ')
      render action: :show, status: :unprocessable_entity
    end
  end

  private

  attr_reader :service

  helper_method :service, :team, :sprint, :update

  def update
    @update ||= Update.find_by!(sprint: sprint, team: team)
  end

  def team
    @team ||= Team.friendly.find(params[:team_id])
  end

  def sprint
    @sprint ||= Sprint.find(params[:sprint_id])
  end
end
