# @label Delivery status
class Sprints::DeliveryStatusComponentPreview < ViewComponent::Preview
  # @label Default
  # ----------------
  #
  def default
    render(Sprints::DeliveryStatusComponent.new(sprint: sprint))
  end

  private

  def sprint
    Struct.new(:delivery_status_summary).new({
      'green' => 3,
      'amber' => 2,
      'red' => 1,
    })
  end
end
