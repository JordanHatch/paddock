class Manage::QuartersController < Manage::BaseController
  before_action :ensure_quarter_is_editable, only: [:reorder_commitments, :do_reorder_commitments]

  def index; end

  def new; end

  def create
    if form.validate(params[:quarter])
      if form.save
        flash.notice = 'Quarter created'
        return redirect_to manage_quarters_path
      end
    end

    render action: :new, status: :unprocessable_entity
  end

  def edit; end

  def update
    if form.validate(params[:quarter])
      if form.save
        flash.notice = 'Quarter updated'
        return redirect_to manage_quarters_path
      end
    end

    render action: :edit, status: :unprocessable_entity
  end

  def reorder_commitments; end

  def do_reorder_commitments
    service = Quarters::ReorderKeyCommitments.run(
      quarter: quarter,
      order: params.fetch(:commitments, {}).fetch(:order, {}).permit!,
    )

    if service.valid?
      redirect_to quarter_path(quarter)
    else
      render action: :reorder_commitments, status: :unprocessable_entity
    end
  end

  private

  helper_method :quarters, :quarter, :form, :key_commitments

  def quarters
    @quarters ||= Quarter.in_reverse_date_order
  end

  def quarter
    @quarter ||= if params.key?(:id)
                   Quarter.friendly.find(params[:id])
                 else
                   Quarter.new
                 end
  end

  def form
    @form ||= Manage::QuarterForm.new(quarter)
  end

  def key_commitments
    @key_commitments ||= quarter.key_commitments.in_order
  end

  def ensure_quarter_is_editable
    unless quarter.editable?
      flash.alert = "The details about this quarter's commitments can no longer be changed."
      return redirect_to quarter_path(quarter)
    end
  end
end
