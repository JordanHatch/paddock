class Manage::SprintsController < Manage::BaseController

  def index; end
  def new; end
  def edit; end

  def create
    if form.valid?
      sprint.assign_attributes(form.to_model_hash)

      if sprint.save
        flash.notice = 'Sprint created'
        return redirect_to manage_sprints_path
      end
    end

    render action: :new
  end

  def update
    if form.valid?
      sprint.assign_attributes(form.to_model_hash)

      if sprint.save
        flash.notice = 'Sprint updated'
        return redirect_to manage_sprints_path
      end
    end

    render action: :edit
  end

  private
  helper_method :sprints, :sprint, :form, :current_sprint

  def sprints
    @sprint ||= Sprint.in_reverse_date_order
  end

  def sprint
    @sprint ||= params.key?(:id) ?
      Sprint.find(params[:id]) :
      Sprint.new
  end

  def form
    @form ||= params.key?(:sprint) ?
      Manage::SprintForm.from_form(params[:sprint], model: sprint) :
      Manage::SprintForm.from_model(sprint)
  end

  def current_sprint
    @current_sprint ||= Sprint.recent.first
  end

  def sprint_params
    params.require(:sprint).permit(:name, :start_on, :end_on)
  end

end
