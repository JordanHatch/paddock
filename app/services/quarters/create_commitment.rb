class Quarters::CreateCommitment < ActiveInteraction::Base
  record :quarter
  hash :attributes, default: {}, strip: false

  validate :form_is_valid?
  validate :quarter_is_editable?

  def commitment
    @commitment ||= quarter.commitments.build
  end

  def form
    @form ||= form_class.from_form(attributes, model: commitment)
  end

  def execute
    commitment.assign_attributes(form.to_model_hash)

    errors.add(:save, 'failed') unless commitment.save
  end

  private

  def form_class
    Quarters::Commitments::CreateForm
  end

  def form_is_valid?
    errors.add(:form, 'is not valid') unless form.valid?
  end

  def quarter_is_editable?
    errors.add(:quarter, 'cannot be edited') unless quarter.editable?
  end
end
