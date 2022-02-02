class Quarters::Commitments::CreateService < BaseService
  attr_reader :commitment, :form

  def initialize(quarter_id:, group_id: nil, attributes: {})
    @quarter_id = quarter_id
    @group_id = group_id
    @attributes = attributes
  end

  def build
    yield validate_quarter

    @commitment = quarter.commitments.build(
      group_id: group_id,
    )
    @form = form_class.from_model(commitment)

    Success(commitment)
  end

  def call
    yield validate_quarter

    @commitment = quarter.commitments.build
    @form = form_class.from_form(attributes, model: commitment)

    commitment.assign_attributes(form.to_model_hash)

    if form.valid? && commitment.save
      Success(commitment)
    else
      Failure(:save_failed)
    end
  end

  def quarter
    @quarter ||= Quarter.find_by(id: quarter_id)
  end

  def form_class
    Quarters::Commitments::CreateForm
  end

  private

  attr_reader :quarter_id, :group_id, :attributes

  def validate_quarter
    if quarter.present?
      Success(quarter)
    else
      Failure(:invalid_quarter)
    end
  end
end
