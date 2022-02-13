require 'rails_helper'

RSpec.describe IndicatorListComponent, type: :component do
  subject! do
    render_inline(described_class.new) do |c|
      c.indicator label: 'Indicator 1'
      c.indicator label: 'Indicator 2'
    end
  end

  it 'renders the indicator list with indicators' do
    expect(rendered_component).to have_css('.indicator-list')
    expect(rendered_component).to have_css('.indicator-list__indicator', text: 'Indicator 1')
    expect(rendered_component).to have_css('.indicator-list__indicator', text: 'Indicator 2')
  end

  describe 'style' do
    subject! do
      render_inline(described_class.new(style: style))
    end

    context 'with a style in the list' do
      let(:style) { :inline_mini }

      it 'sets the correct class name' do
        expect(rendered_component).to have_css('.indicator-list.indicator-list--inline-mini')
      end
    end

    context 'with a style not in the list' do
      let(:style) { :foo }

      it 'does not set a class name' do
        expect(rendered_component).to_not have_css('.indicator-list--foo')
      end
    end
  end
end
