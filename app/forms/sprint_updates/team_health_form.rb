class SprintUpdates::TeamHealthForm < BaseForm
  property :team_health

  validation do
    params do
      required(:team_health).filled(:string)
    end
  end
end
