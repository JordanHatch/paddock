class SprintUpdates::DeliveryStatusForm < BaseForm
  attribute :delivery_status, Types::Nominal::String

  validation do
    params do
      required(:delivery_status).filled(:string)
    end
  end
end
