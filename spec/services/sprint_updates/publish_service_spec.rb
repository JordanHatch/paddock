require 'rails_helper'

RSpec.describe SprintUpdates::PublishService do
  let(:update) { create(:draft_sprint_update) }
  let(:flow) { stub }

  describe '#build' do
    subject do
      described_class.build(
        team_id: update.team.id,
        sprint_id: update.sprint.id,
        flow: flow,
      )
    end

    context 'when the flow is valid' do
      before(:each) do
        flow.expects(:valid?).returns(true)
      end

      it 'is successful' do
        expect(subject).to be_success
        expect(subject).to_not be_failure
      end
    end

    context 'when the flow is not valid' do
      before(:each) do
        flow.expects(:valid?).returns(false)
      end

      it 'is not successful' do
        expect(subject).to be_failure
        expect(subject).to_not be_success
      end
    end

    context 'when the update is not a draft' do
      let(:update) { create(:published_sprint_update) }

      before(:each) do
        flow.expects(:valid?).returns(true)
      end

      it 'is not successful' do
        expect(subject).to be_failure
        expect(subject).to_not be_success
      end
    end
  end

  describe '#publish' do
    subject do
      described_class.call(
        team_id: update.team.id,
        sprint_id: update.sprint.id,
        flow: flow,
      )
    end

    context 'when the flow is valid' do
      before(:each) do
        flow.expects(:valid?).returns(true)
      end

      it 'is successful' do
        expect(subject).to be_success
        expect(subject).to_not be_failure
      end

      it 'sets the state to published' do
        subject
        expect(update.reload.state).to eq('published')
      end
    end

    context 'when the flow is not valid' do
      before(:each) do
        flow.expects(:valid?).returns(false)
      end

      it 'is not successful' do
        expect(subject).to be_failure
        expect(subject).to_not be_success
      end
    end

    context 'when the update is not a draft' do
      let(:update) { create(:published_sprint_update) }

      before(:each) do
        flow.expects(:valid?).returns(true)
      end

      it 'is not successful' do
        expect(subject).to be_failure
        expect(subject).to_not be_success
      end
    end
  end
end
