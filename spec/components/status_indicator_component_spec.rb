require 'rails_helper'

RSpec.describe StatusIndicatorComponent, type: :component do
  before(:each) do
    render_inline(described_class.new(status: status, label: label, position: position))
  end

  let(:status) { :green }
  let(:label) { 'Green' }
  let(:position) { nil }

  it 'renders the status' do
    expect(rendered_component).to have_css('.status-indicator', text: label)
    expect(rendered_component).to have_css('.status-indicator.status-indicator--green')
    expect(rendered_component).to have_css('.status-indicator .status-indicator__circle')
  end

  context 'when label is nil' do
    let(:label) { nil }

    it 'renders an mdash' do
      expect(rendered_component).to have_css('.status-indicator', text: '—')
    end
  end

  describe 'position' do
    context 'when :before' do
      let(:position) { :before }

      it 'renders the circle before the label' do
        expect(rendered_component).to match(/<div class='status-indicator__circle'><\/div>\nGreen/)
      end
    end

    context 'when :after' do
      let(:position) { :after }

      it 'renders the circle after the label' do
        expect(rendered_component).to match(/Green\n<div class='status-indicator__circle'><\/div>/)
      end
    end

    context 'when nil' do
      let(:position) { nil }

      it 'renders the circle after the label' do
        expect(rendered_component).to match(/Green\n<div class='status-indicator__circle'><\/div>/)
      end
    end
  end
end
