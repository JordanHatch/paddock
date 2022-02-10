class Quarters::CommodityFilterComponent < ViewComponent::Base
  extend Dry::Initializer

  option :quarter
  option :selected_commodity, type: proc(&:to_s)

  private

  def options
    Commitment.commodities.values.to_h do |key|
      [I18n.t(key, scope: %w[commitments commodities]), key]
    end
  end
end
