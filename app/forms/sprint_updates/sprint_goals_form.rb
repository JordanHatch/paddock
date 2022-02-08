class SprintUpdates::SprintGoalsForm < BaseForm
  property :sprint_goals

  def sprint_goals=(value)
    value.reject!(&:blank?) if value.is_a?(Array)
    super(value)
  end

  def prepopulate!
    (5 - sprint_goals.size).times do
      sprint_goals << ''
    end
  end

  validation do
    params do
      required(:sprint_goals).value(:array?, min_size?: 1)
    end
  end
end
