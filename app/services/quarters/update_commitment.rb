class Quarters::UpdateCommitment < ActiveInteraction::Base
  record :commitment
  interface :form_class, from: BaseForm
  hash :attributes, default: {}, strip: false

  validate :form_is_valid?

  def form
    @form ||= if attributes.any?
                form_class.from_form(attributes, model: commitment)
              else
                form_class.from_model(commitment)
              end
  end

  def execute
    commitment.assign_attributes(form.to_model_hash)

    errors.add(:save, 'failed') unless commitment.save
  end

  private

  def form_is_valid?
    errors.add(:form, 'is invalid') unless form.valid?
  end
end
