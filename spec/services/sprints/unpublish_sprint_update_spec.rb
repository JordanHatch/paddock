require 'rails_helper'

RSpec.describe Sprints::UnpublishSprintUpdate do
  let(:update) { create(:published_sprint_update) }

  describe '.valid?' do
    subject { described_class.new(update: update) }

    context 'with valid arguments' do
      it 'is valid' do
        expect(subject).to be_valid
      end
    end

    context 'when the update is missing' do
      let(:update) { nil }

      it 'is not valid' do
        expect(subject).to_not be_valid
        expect(subject.errors).to have_key(:update)
      end
    end

    context 'when the update cannot be unpublished' do
      let(:update) { create(:draft_sprint_update) }

      it 'is not valid' do
        expect(subject).to_not be_valid
        expect(subject.errors).to have_key(:update)
      end
    end
  end

  describe '.run' do
    subject { described_class.run(update: update) }

    context 'with valid arguments' do
      it 'is valid' do
        expect(subject).to be_valid
      end

      it 'updates the state to "draft"' do
        expect { subject }.to change { update.reload.state }.to('draft')
      end
    end

    context 'when saving the update fails' do
      before(:each) do
        update.expects(:save).returns(false)
      end

      it 'is not valid' do
        expect(subject).to_not be_valid
        expect(subject.errors).to have_key(:save)
      end
    end
  end
end
