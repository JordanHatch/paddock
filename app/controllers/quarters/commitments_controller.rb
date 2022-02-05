class Quarters::CommitmentsController < Quarters::BaseController
  def index; end

  def show; end

  def new
    @service = Quarters::CreateCommitment.new(
      quarter: quarter,
      attributes: { group_id: params[:group] }
    )

    redirect_to quarter_commitments_path(quarter) unless @service.valid?
  end

  def create
    @service = Quarters::CreateCommitment.run(
      quarter: quarter,
      attributes: params[:commitment].permit!,
    )

    if @service.valid?
      redirect_to quarter_commitment_form_path(quarter, @service.commitment, :overview)
    else
      render action: :new, status: :unprocessable_entity
    end
  end

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
      render action: :edit, status: :unprocessable_entity
    end
  end

  private

  attr_reader :service

  helper_method :groups_with_commitments, :commitment, :service, :flow

  def groups_with_commitments
    @groups_with_commitments ||= Group.in_order.includes(:commitments)
  end

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
