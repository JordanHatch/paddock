class Quarters::Commitments::TeamsForm < BaseForm
  attribute :team_ids, Types::Nominal::Array

  deserialize_model do |attributes, model|
    attributes[:team_ids] = model.teams.map(&:id)
  end
end
