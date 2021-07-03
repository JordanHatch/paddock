class SprintUpdates::SprintGoalsForm < BaseForm
  attribute :sprint_goals, Types::Nominal::Array

  preprocess do |form|
    (5 - form.sprint_goals.size).times do
      form.sprint_goals << ''
    end
  end

  before_validate do |form|
    form[:sprint_goals].reject!(&:blank?)
  end
end
