require 'rails_helper'

RSpec.describe IndicatorComponent, type: :component do
  let(:label) { 'Label' }
  let(:value) { 'Value' }

  subject! do
    render_inline(described_class.new(label: label)) do
      value
    end
  end

  it 'renders an indicator' do
    expect(rendered_component).to have_css('.indicator-list__indicator')
    expect(rendered_component).to have_css('.indicator-list__label', text: label)
    expect(rendered_component).to have_css('.indicator-list__value', text: value)
  end

  context 'when the label is blank' do
    let(:label) { nil }

    it 'does not render the label' do
      expect(rendered_component).to_not have_css('.indicator-list__label')
    end

    it 'adds the no-label class' do
      expect(rendered_component).to have_css('.indicator-list__indicator.indicator-list__indicator--no-label')
    end
  end

  context 'rendering a StatusIndicatorComponent' do
    subject! do
      render_inline(described_class.new) do |c|
        c.status status: :green, label: 'Green'
      end
    end

    it 'renders the component' do
      expect(rendered_component).to have_text('Green')
    end
  end
end
