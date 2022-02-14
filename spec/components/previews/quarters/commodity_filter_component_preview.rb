# @label Commodity filter
class Quarters::CommodityFilterComponentPreview < ViewComponent::Preview
  # @label Default
  # ----------------
  #
  # @param selected_commodity select ["", meat, fish, eggs]
  def default(selected_commodity: nil)
    render(Quarters::CommodityFilterComponent.new(quarter: quarter, selected_commodity: selected_commodity))
  end

  private

  def quarter
    Struct.new(:to_param).new('123')
  end
end
