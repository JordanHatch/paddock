class Quarters::UpdateCommitment < ActiveInteraction::Base
  record :commitment
  interface :form_class, from: BaseForm
  hash :attributes, default: {}, strip: false

  validate :form_is_valid?
  validate :quarter_is_editable?

  def form
    @form ||= form_class.new(commitment).tap do |form|
                form.deserialize(attributes)
              end
  end

  def execute
    errors.add(:save, 'failed') unless form.save
  end

  private

  def form_is_valid?
    errors.add(:form, 'is invalid') unless form.valid?
  end

  def quarter_is_editable?
    errors.add(:commitment, 'cannot be edited') unless commitment.quarter.editable?
  end
end
