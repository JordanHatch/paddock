require 'rails_helper'

RSpec.describe Quarters::CommodityFilterComponent, type: :component do
  let(:quarter) { create(:quarter) }
  let(:selected_commodity) { nil }

  let(:args) do
    {
      quarter: quarter,
      selected_commodity: selected_commodity,
    }
  end

  def label(key)
    I18n.t(key, scope: %w[commitments commodities])
  end

  before(:each) do
    render_inline(described_class.new(**args)).to_html
  end

  it 'renders a form' do
    expected_options = ['All commodities'] + Commitment::COMMODITIES.map do |key|
      label(key)
    end

    expect(rendered_component).to have_select(:commodity, options: expected_options)
  end

  context 'with the selected_commodity' do
    let(:selected_commodity) { 'meat' }

    it 'selects the current commodity' do
      expect(rendered_component).to have_select(:commodity, selected: label(selected_commodity))
    end
  end

  context 'with no selected_commodity' do
    let(:selected_commodity) { nil }

    it 'selects the current commodity' do
      expect(rendered_component).to have_select(:commodity, selected: nil)
    end
  end
end
