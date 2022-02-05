class Sprints::UpdateSprintUpdate < ActiveInteraction::Base
  record :update
  interface :form_class, from: BaseForm
  hash :attributes, default: {}, strip: false

  def form
    @form ||= if attributes.any?
                form_class.from_form(attributes, model: update)
              else
                form_class.from_model(update)
              end
  end

  def team
    update.team
  end

  def sprint
    update.sprint
  end

  def execute
    if form.valid?
      update.assign_attributes(form.to_model_hash)
      update.save
    else
      errors.add(:form, 'is invalid')
    end
  end
end
