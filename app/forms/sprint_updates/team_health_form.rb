class SprintUpdates::TeamHealthForm < BaseForm
  attribute :team_health, Types::Nominal::String

  validation do
    required(:team_health).filled(:string)
  end
end
