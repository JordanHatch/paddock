# @label Status indicator
class StatusIndicatorComponentPreview < ViewComponent::Preview
  # @label Default
  # ----------------
  #
  # @param status select [green, amber, red]
  # @param position select [before, after]
  # @param label
  def default(status: :green, label: 'Green', position: nil)
    render StatusIndicatorComponent.new(status: status, label: label, position: position)
  end
end
