require 'rails_helper'

RSpec.describe SprintUpdates::UnpublishService do
  describe '.unpublish' do
    subject do
      described_class.call(
        team_id: update.team.id,
        sprint_id: update.sprint.id,
      )
    end

    context 'when the update state is "published"' do
      let(:update) { create(:published_sprint_update) }

      it 'is successful' do
        expect(subject).to be_success
        expect(subject).to_not be_failure
      end

      it 'unpublishes the update' do
        expect(subject.update.reload.state).to eq('draft')
      end

      context 'when saving fails' do
        before(:each) do
          Update.any_instance.stubs(:save).returns(false)
        end

        it 'is unsuccessful' do
          expect(subject).to be_failure
          expect(subject).to_not be_success
        end

        it 'returns an error' do
          expect(subject.result.failure).to contain_exactly(:unpublish_failed)
        end
      end
    end

    context 'when the sprint does not exist' do
      let(:team) { create(:team) }

      subject { described_class.build(team_id: team.id, sprint_id: 'foo') }

      it 'raises an ActiveRecord::RecordNotFound exception' do
        expect { subject.result.failure }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the team does not exist' do
      let(:sprint) { create(:sprint) }

      subject { described_class.build(team_id: 'foo', sprint_id: sprint.id) }

      it 'raises an ActiveRecord::RecordNotFound exception' do
        expect { subject.result.failure }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when the update does not exist' do
      let(:sprint) { create(:sprint) }
      let(:team) { create(:team) }

      subject { described_class.build(team_id: team.id, sprint_id: sprint.id) }

      it 'initialises a new update object' do
        expect(subject.update).to_not be_persisted
      end
    end

    context 'when the update state is "not_started"' do
      let(:update) { create(:not_started_sprint_update) }

      it 'is not successful' do
        expect(subject).to be_failure
        expect(subject).to_not be_success
      end

      it 'returns an error' do
        expect(subject.result.failure).to contain_exactly(:update_not_published)
      end
    end

    context 'when the update state is "draft"' do
      let(:update) { create(:draft_sprint_update) }

      it 'is not successful' do
        expect(subject).to be_failure
        expect(subject).to_not be_success
      end

      it 'returns an error' do
        expect(subject.result.failure).to contain_exactly(:update_not_published)
      end
    end
  end
end
