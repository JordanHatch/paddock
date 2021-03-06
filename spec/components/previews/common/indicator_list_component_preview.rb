# @label Indicator list
class Common::IndicatorListComponentPreview < ViewComponent::Preview
  # @label Default stacked
  # ----------------
  #
  def default
    render Common::IndicatorListComponent.new do |c|
      c.indicator label: 'Delivery status' do |i|
        i.status status: :green, label: 'Green'
      end

      c.indicator label: 'OKR status' do |i|
        i.status status: :amber, label: 'Amber'
      end

      c.indicator label: 'Team health' do |_i|
        '5 / 10'
      end
    end
  end

  # @label Inline
  # ----------------
  #
  def inline
    render Common::IndicatorListComponent.new(style: :inline) do |c|
      c.indicator label: 'Delivery status' do |i|
        i.status status: :green, label: 'Green'
      end

      c.indicator label: 'OKR status' do |i|
        i.status status: :amber, label: 'Amber'
      end

      c.indicator label: 'Team health' do |_i|
        '5 / 10'
      end
    end
  end

  # @label Inline mini
  # ----------------
  #
  def inline_mini
    render Common::IndicatorListComponent.new(style: :inline_mini) do |c|
      c.indicator label: 'Delivery' do |i|
        i.status status: :green, label: 'Green'
      end

      c.indicator label: 'OKRs' do |i|
        i.status status: :amber, label: 'Amber'
      end

      c.indicator label: 'Team' do |_i|
        '5 / 10'
      end

      c.indicator do |_i|
        'Awaiting update'
      end
    end
  end
end
