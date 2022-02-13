class Sprints::DeliveryStatusComponentPreview < ViewComponent::Preview
  # Indicator with label and status
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
