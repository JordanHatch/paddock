class SprintUpdates::NextSprintForm < BaseForm
  property :next_sprint_goals

  def next_sprint_goals=(value)
    value = [] unless value.is_a?(Array)
    super(value.reject(&:blank?))
  end

  def prepopulate!
    self.next_sprint_goals = [] unless next_sprint_goals.is_a?(Array)

    (5 - next_sprint_goals.size).times do
      next_sprint_goals << ''
    end
  end

  validation do
    params do
      required(:next_sprint_goals).value(:array?)
    end
  end
end
