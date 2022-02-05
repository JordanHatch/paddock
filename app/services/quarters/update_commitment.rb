class Quarters::UpdateCommitment < ActiveInteraction::Base
  class RequiredArgumentMissing < StandardError; end

  record :commitment
  interface :form_class, from: BaseForm
  hash :attributes, default: {}, strip: false

  set_callback :type_check, :after, lambda { |service|
    raise RequiredArgumentMissing if service.errors.key?(:commitment) || service.errors.key?(:form_class)
  }

  def form
    @form ||= if attributes.any?
                form_class.from_form(attributes, model: commitment)
              else
                form_class.from_model(commitment)
              end
  end

  def execute
    if form.valid?
      commitment.assign_attributes(form.to_model_hash)
      commitment.save
    else
      errors.add(:form, 'is invalid')
    end
  end
end
