class SprintUpdates::NextSprintForm < BaseForm
  attribute :next_sprint_goals, Types::Nominal::Array

  preprocess do |form|
    (5 - form.next_sprint_goals.size).times do
      form.next_sprint_goals << ''
    end
  end

  before_validate do |form|
    form[:next_sprint_goals].reject!(&:blank?)
  end
end
