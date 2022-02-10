class Quarters::Commitments::ActionsForm < BaseForm
  property :actions

  def actions=(value)
    value = [] unless value.is_a?(Array)
    super(value.reject(&:blank?))
  end

  def prepopulate!
    self.actions = [] unless actions.is_a?(Array)

    (5 - actions.size).times do
      actions << ''
    end
  end
end
