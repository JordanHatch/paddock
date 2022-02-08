class Manage::TeamsController < Manage::BaseController
  def index; end

  def new
    form.group_id = params[:group] if params[:group].present?
  end

  def edit; end

  def create
    if form.validate(params[:team]) && form.save
      flash.notice = 'Team created'
      return redirect_to manage_teams_path
    end

    render action: :new, status: :unprocessable_entity
  end

  def update
    if form.validate(params[:team]) && form.save
      flash.notice = 'Team updated'
      return redirect_to manage_teams_path
    end

    render action: :edit, status: :unprocessable_entity
  end

  private

  helper_method :groups, :team, :form

  def groups
    @groups ||= Group.with_teams.in_order
  end

  def team
    @team ||= if params.key?(:id)
                Team.friendly.find(params[:id])
              else
                Team.new
              end
  end

  def form
    @form ||= Manage::TeamForm.new(team)
  end
end
