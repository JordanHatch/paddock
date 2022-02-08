class Sprints::UpdateSprintUpdate < ActiveInteraction::Base
  record :update
  interface :form_class, from: Reform::Form
  hash :attributes, default: {}, strip: false

  def form
    @form ||= form_class.new(update).tap do |form|
      form.deserialize(attributes)
    end
  end

  def team
    update.team
  end

  def sprint
    update.sprint
  end

  def execute
    errors.add(:save, 'failed') unless form.save
  end
end
