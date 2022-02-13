class StatusIndicatorComponentPreview < ViewComponent::Preview
  # Default indicator list
  # ----------------
  #
  # @param status select [green, amber, red]
  # @param label
  def default(status: :green, label: 'Green')
    render StatusIndicatorComponent.new(status: status, label: label)
  end
end
