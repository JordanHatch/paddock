class SprintUpdates::TeamHealthForm < BaseForm
  attribute :team_health, Types::Nominal::String

  validation do
    params do
      required(:team_health).filled(:string)
    end
  end
end
