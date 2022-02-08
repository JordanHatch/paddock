class Quarters::Commitments::ActionsForm < BaseForm
  property :actions

  def actions=(value)
    super(value.reject!(&:blank?))
  end

  def prepopulate!
    (5 - actions.size).times do
      actions << ''
    end
  end
end
