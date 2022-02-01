class Quarters::Commitments::UpdateService < BaseService
  attr_reader :form

  def initialize(commitment_id:, form_class:, attributes: {})
    @commitment_id = commitment_id
    @form_class = form_class
    @attributes = attributes
  end

  def build
    yield List::Validated[
             validate_object,
           ].traverse.to_result

    @form = form_class.from_model(commitment)
    prevalidate_form

    Success(commitment)
  end

  def call
    yield List::Validated[
             validate_object,
           ].traverse.to_result

    @form = form_class.from_form(attributes, model: commitment)
    commitment.assign_attributes(form.to_model_hash)

    if form.valid? && commitment.save
      Success(commitment)
    else
      Failure(:save_failed)
    end
  end

  def commitment
    @commitment ||= Commitment.find(commitment_id)
  end

  private

  attr_reader :commitment_id, :form_class, :attributes

  def validate_object
    if commitment.present?
      Valid(commitment)
    else
      Invalid(:update_cannot_be_edited)
    end
  end

  def prevalidate_form
    form.validate if form.started?
  end
end
