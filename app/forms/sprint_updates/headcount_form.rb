class SprintUpdates::HeadcountForm < BaseForm
  attribute :current_headcount, Types::Nominal::Integer
  attribute :vacant_roles, Types::Nominal::Integer

  validation do
    required(:current_headcount).filled(:integer)
    required(:vacant_roles).filled(:integer)
  end
end
