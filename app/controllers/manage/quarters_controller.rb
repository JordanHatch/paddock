class Manage::QuartersController < Manage::BaseController
  before_action :ensure_quarter_is_editable, only: [:reorder_commitments, :do_reorder_commitments]

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

  helper_method :quarter, :key_commitments

  def quarter
    @quarter ||= Quarter.find(params[:id])
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
