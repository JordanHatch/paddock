class SprintUpdates::DeliveryStatusForm < BaseForm
  property :delivery_status

  validation do
    params do
      required(:delivery_status).filled
    end
  end
end
