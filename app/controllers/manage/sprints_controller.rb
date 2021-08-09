class Manage::SprintsController < Manage::BaseController

  def index; end
  def edit; end

  def update
    sprint.assign_attributes(sprint_params)

    if sprint.save
      flash.notice = 'Sprint updated'
      redirect_to manage_sprints_path
    else
      render action: :edit
    end
  end

  private
  helper_method :sprints, :sprint, :current_sprint

  def sprints
    @sprint ||= Sprint.in_reverse_date_order
  end

  def sprint
    @sprint ||= params.key?(:id) ?
      Sprint.find(params[:id]) :
      Sprint.new
  end

  def current_sprint
    @current_sprint ||= Sprint.recent.first
  end

  def sprint_params
    params.require(:sprint).permit(:name, :start_on, :end_on)
  end

end
