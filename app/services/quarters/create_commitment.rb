class Quarters::CreateCommitment < ActiveInteraction::Base
  class MissingQuarter < StandardError; end

  record :quarter
  hash :attributes, default: {}, strip: false

  set_callback :type_check, :after, -> {
    raise MissingQuarter unless quarter.present?
  }

  def commitment
    @commitment ||= quarter.commitments.build
  end

  def form
    @form ||= form_class.from_form(attributes, model: commitment)
  end

  def execute
    if form.valid?
      commitment.assign_attributes(form.to_model_hash)
      commitment.save
    else
      errors.add(:form, 'is invalid')
    end
  end

  private

  def form_class
    Quarters::Commitments::CreateForm
  end
end
