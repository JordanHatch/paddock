require 'rails_helper'

RSpec.describe SprintUpdates::PublishService do

  let(:update) { create(:draft_sprint_update) }
  let(:flow) { stub }

  subject {
    described_class.call(
      team_id: update.team.id,
      sprint_id: update.sprint.id,
      flow: flow,
    )
  }

  describe '#call' do
    context 'when the flow is valid' do
      before(:each) {
        flow.expects(:valid?).returns(true)
      }

      it 'is successful' do
        expect(subject).to be_success
      end

      it 'sets the state to published' do
        subject
        expect(update.reload.state).to eq('published')
      end
    end
  end
end
