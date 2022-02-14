# @label Indicator
class Common::IndicatorComponentPreview < ViewComponent::Preview
  # @!group Indicators

  # @label Indicator with label and status
  # ----------------
  #
  # @param label
  def with_label_and_status(label: 'Delivery')
    render(Common::IndicatorComponent.new(label: label)) do |c|
      c.status status: :green, label: 'Green'
    end
  end

  # @label Indicator with no label
  # ----------------
  #
  def with_no_label
    render(Common::IndicatorComponent.new(label: nil)) do |_c|
      'Label text'
    end
  end

  # @!endgroup
end
