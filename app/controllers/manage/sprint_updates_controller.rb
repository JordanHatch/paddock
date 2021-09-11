class Manage::SprintUpdatesController < Manage::BaseController
  def show
    @service ||= SprintUpdates::UnpublishService.build(team_id: params[:team_id],
                                                       sprint_id: params[:sprint_id])
  end

  def unpublish
    @service ||= SprintUpdates::UnpublishService.unpublish(team_id: params[:team_id],
                                                           sprint_id: params[:sprint_id])

    if service.result.success?
      flash.notice = I18n.t(:success, scope: %w[services sprint_updates unpublish])
      redirect_to update_path(service.sprint, service.team)
    else
      flash.alert = service.errors.map { |error|
        I18n.t(error, scope: %w[services sprint_updates unpublish])
      }.join(', ')
      render action: :show, status: :unprocessable_entity
    end
  end

  private

  attr_reader :service

  helper_method :service, :team, :update, :sprint

  def team
    service.team
  end

  def update
    service.update
  end

  def sprint
    service.sprint
  end
end
