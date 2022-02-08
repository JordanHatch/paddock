class SprintUpdates::SprintGoalsForm < BaseForm
  property :sprint_goals

  def sprint_goals=(value)
    super(value.reject!(&:blank?))
  end

  def prepopulate!
    (5 - sprint_goals.size).times do
      sprint_goals << ''
    end
  end
end
