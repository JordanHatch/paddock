class Manage::QuartersController < Manage::BaseController
  def reorder_commitments; end

  def do_reorder_commitments
    quarter_params = params.require(:commitments).permit(order: {})
    order = quarter_params[:order].to_h

    service = Quarters::Commitments::ReorderService.call(
      quarter_id: quarter.id,
      order: order,
    )

    if service.success?
      redirect_to quarter_path(quarter)
    else
      redirect_to reorder_commitments_manage_quarter_path(quarter.id)
    end
  end

  private

  helper_method :quarter, :commitments

  def quarter
    @quarter ||= Quarter.find(params[:id])
  end

  def commitments
    @commitments ||= quarter.commitments.in_order
  end
end
