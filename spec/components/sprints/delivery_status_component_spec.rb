require 'rails_helper'

RSpec.describe Sprints::DeliveryStatusComponent, type: :component do
  let(:sprint) { build(:sprint) }
  let(:status_counts) do
    {
      'green' => 3,
      'amber' => 2,
      'red' => 1,
    }
  end

  before(:each) do
    sprint.stubs(:delivery_status_summary).returns(status_counts)
    render_inline(described_class.new(sprint: sprint))
  end

  it 'renders green, amber and red statuses' do
    expect(rendered_component).to have_css('.sprint-delivery-status__item--status-green', text: "3\nGreen")
    expect(rendered_component).to have_css('.sprint-delivery-status__item--status-amber', text: "2\nAmber")
    expect(rendered_component).to have_css('.sprint-delivery-status__item--status-red', text: "1\nRed")
  end

  context 'when a status count is nil' do
    let(:status_counts) do
      {
        'green' => nil,
        'amber' => 2,
        'red' => 1,
      }
    end

    it 'renders the status as zero' do
      expect(rendered_component).to have_css('.sprint-delivery-status__item--status-green', text: "0\nGreen")
    end
  end
end
