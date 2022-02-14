# @label Status indicator
class Common::StatusIndicatorComponentPreview < ViewComponent::Preview
  # @label Default
  # ----------------
  #
  # @param status select [green, amber, red]
  # @param position select [before, after]
  # @param label
  def default(status: :green, label: 'Green', position: nil)
    render Common::StatusIndicatorComponent.new(status: status, label: label, position: position)
  end
end
