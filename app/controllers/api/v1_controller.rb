class Api::V1Controller < Api::BaseController
  def sprints
    @sprints = Sprint.order(:id)
                     .page(params[:page])
                     .per(per_page)
  end

  def sprint
    @sprint = Sprint.find(params[:id])
  end

  def sprint_updates
    scope = params.key?(:sprint) ? Update.by_sprint_id(params[:sprint]) : Update

    @sprint_updates = scope.published
                           .order(:id)
                           .includes(:sprint, :group, :team, :issues)
                           .page(params[:page])
                           .per(per_page)
  end

  def sprint_update
    @sprint_update = Update.published
                           .includes(:sprint, :group, :team, :issues)
                           .find(params[:id])
  end

  def teams
    @teams = Team.order(:id)
                 .page(params[:page])
                 .per(per_page)
  end

  def team
    @team = Team.find(params[:id])
  end

  private

  def per_page
    params[:per_page] || 20
  end
end
