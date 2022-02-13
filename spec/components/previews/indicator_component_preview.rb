class IndicatorComponentPreview < ViewComponent::Preview
  # @!group Indicators

  # Indicator with label and status
  # ----------------
  #
  # @param label
  def with_label_and_status(label: 'Delivery')
    render(IndicatorComponent.new(label: label)) do |c|
      c.status status: :green, label: 'Green'
    end
  end

  # Indicator with no label
  # ----------------
  #
  # @param label
  def with_no_label
    render(IndicatorComponent.new(label: nil)) do |c|
      "Label text"
    end
  end

  # @!endgroup
end
