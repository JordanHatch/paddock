class SprintUpdates::OkrStatusForm < BaseForm
  attribute :okr_status, Types::Nominal::String

  validation do
    params do
      required(:okr_status).filled(:string)
    end
  end
end
