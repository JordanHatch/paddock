require 'rails_helper'

RSpec.describe Sprints::PublishSprintUpdate do
  let(:update) { create(:draft_sprint_update) }
  let(:flow) do
    SprintUpdates::UpdateFlow.new(
      current_form_id: :submit,
      object: update,
    )
  end

  describe '.valid?' do
    subject do
      described_class.new(
        update: update,
        flow: flow,
      )
    end

    context 'when the flow is valid' do
      before(:each) do
        flow.expects(:valid?).returns(true)
      end

      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when the flow is invalid' do
      before(:each) do
        flow.expects(:valid?).returns(false)
      end

      it 'is invalid' do
        expect(subject).to_not be_valid
        expect(subject.errors).to have_key(:flow)
      end
    end

    context 'when the update is missing' do
      let(:update) { nil }

      it 'is invalid' do
        expect(subject).to_not be_valid
        expect(subject.errors).to have_key(:update)
      end
    end

    context 'when the flow is missing' do
      let(:flow) { nil }

      it 'is invalid' do
        expect(subject).to_not be_valid
        expect(subject.errors).to have_key(:flow)
      end
    end

    context 'when the flow is not a flow object' do
      let(:flow) { Object.new }

      it 'is invalid' do
        expect(subject).to_not be_valid
        expect(subject.errors).to have_key(:flow)
      end
    end

    context 'when the update is not a draft' do
      let(:update) { create(:published_sprint_update) }

      it 'is invalid' do
        expect(subject).to_not be_valid
        expect(subject.errors).to have_key(:update)
      end
    end
  end

  describe '.run' do
    subject do
      described_class.run(
        update: update,
        flow: flow,
      )
    end

    context 'when the flow is valid' do
      before(:each) do
        flow.expects(:valid?).returns(true)
      end

      it 'is valid' do
        expect(subject).to be_valid
      end

      it 'publishes the update' do
        expect { subject }.to change { update.reload.state }.to('published')
      end
    end

    context 'when the flow is not valid' do
      before(:each) do
        flow.expects(:valid?).returns(false)
      end

      it 'does not publish the update' do
        expect { subject }.to_not(change { update.reload.state })
      end
    end

    context 'when saving the update fails' do
      before(:each) do
        flow.expects(:valid?).returns(true)
        update.expects(:save).returns(false)
      end

      it 'is not valid' do
        expect(subject).to_not be_valid
        expect(subject.errors).to have_key(:save)
      end
    end
  end
end
