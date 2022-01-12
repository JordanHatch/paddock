class Quarters::CommitmentsController < Quarters::BaseController

  def show; end

  def edit
    @service = Quarters::Commitments::UpdateService.build(
      commitment_id: commitment.id,
      form_class: flow.form_class,
    )
  end

  def update
    @service = Quarters::Commitments::UpdateService.call(
      commitment_id: commitment.id,
      form_class: flow.form_class,
      attributes: params[:commitment],
    )

    if @service.success?
      if flow.last_form?
        redirect_to quarter_commitment_path(quarter, commitment)
      else
        redirect_to quarter_commitment_form_path(quarter, commitment, flow.next_form_id)
      end
    else
      render :edit
    end
  end

  private

  attr_reader :service

  helper_method :commitment, :service, :flow

  def commitment
    @commitment ||= quarter.commitments.find(params[:id])
  end

  def flow
    @flow ||= Quarters::CommitmentFlow.new(
      current_form_id: @form_id || params[:form],
      object: commitment,
    )
  end
end
