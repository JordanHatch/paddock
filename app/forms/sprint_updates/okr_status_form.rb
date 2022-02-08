class SprintUpdates::OkrStatusForm < BaseForm
  property :okr_status

  validation do
    params do
      required(:okr_status).filled(:string)
    end
  end
end
