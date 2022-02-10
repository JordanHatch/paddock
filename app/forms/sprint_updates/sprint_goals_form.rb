class SprintUpdates::SprintGoalsForm < BaseForm
  property :sprint_goals

  def sprint_goals=(value)
    value = [] unless value.is_a?(Array)
    super(value.reject(&:blank?))
  end

  def prepopulate!
    self.sprint_goals = [] unless sprint_goals.is_a?(Array)

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
