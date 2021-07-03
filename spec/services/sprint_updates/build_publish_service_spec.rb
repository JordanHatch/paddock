require 'rails_helper'

RSpec.describe SprintUpdates::BuildPublishService do

  let(:update) { create(:draft_sprint_update) }
  let(:flow) { stub }

  subject {
    described_class.call(
      team_id: update .team.id,
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
    end

    context 'when the flow is not valid' do
      before(:each) {
        flow.expects(:valid?).returns(false)
      }

      it 'is not successful' do
        expect(subject).to be_failure
      end
    end

    context 'when the update is not a draft' do
      let(:update) { create(:published_sprint_update) }

      it 'is not successful' do
        expect(subject).to be_failure
      end
    end
  end
end
