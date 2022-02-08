class Manage::SprintsController < Manage::BaseController
  def index; end

  def new
    form.prepopulate!
  end

  def edit; end

  def create
    if form.validate(params[:sprint])
      if form.save
        flash.notice = 'Sprint created'
        return redirect_to manage_sprints_path
      end
    end

    render action: :new, status: :unprocessable_entity
  end

  def update
    if form.validate(params[:sprint])
      if form.save
        flash.notice = 'Sprint updated'
        return redirect_to manage_sprints_path
      end
    end

    render action: :edit, status: :unprocessable_entity
  end

  private

  helper_method :sprints, :sprint, :form, :current_sprint

  def sprints
    @sprints ||= Sprint.in_reverse_date_order
  end

  def sprint
    @sprint ||= if params.key?(:id)
                  Sprint.find(params[:id])
                else
                  Sprint.new
                end
  end

  def form
    @form ||= Manage::SprintForm.new(sprint)
  end

  def current_sprint
    @current_sprint ||= Sprint.recent.first
  end

  def sprint_params
    params.require(:sprint).permit(:name, :start_on, :end_on)
  end
end
