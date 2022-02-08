class SprintUpdates::HeadcountForm < BaseForm
  property :current_headcount
  property :vacant_roles

  validation do
    params do
      required(:current_headcount).filled(:integer)
      required(:vacant_roles).filled(:integer)
    end
  end
end
