require 'rails_helper'

RSpec.describe SprintUpdates::UpdateFlow do
  let(:sprint_update) { build(:draft_sprint_update) }

  describe '#initialize' do
    it 'sets the object attribute to the sprint_update' do
      flow = described_class.new(
        current_form_id: nil,
        sprint_update: sprint_update,
      )
      expect(flow.send(:object)).to eq(sprint_update)
    end
  end
end
