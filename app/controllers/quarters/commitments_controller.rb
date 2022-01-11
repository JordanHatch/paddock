class Quarters::CommitmentsController < Quarters::BaseController

  def show; end

  def edit; end

  def update
    commitment.assign_attributes(commitment_params)

    if commitment.save
      redirect_to quarter_commitment_path(quarter, commitment)
    else
      render action: :edit
    end
  end

  private

  helper_method :commitment

  def commitment
    @commitments ||= quarter.commitments.find(params[:id])
  end

  def commitment_params
    params.require(:commitment).permit(:name, :number, :overview, :actions, :benefits)
  end
end
