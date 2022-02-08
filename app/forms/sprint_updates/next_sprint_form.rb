class SprintUpdates::NextSprintForm < BaseForm
  property :next_sprint_goals

  def next_sprint_goals=(value)
    super(value.reject!(&:blank?))
  end

  def prepopulate!
    (5 - next_sprint_goals.size).times do
      self.next_sprint_goals << ''
    end
  end
end
