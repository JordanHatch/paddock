require 'rails_helper'

RSpec.describe SprintUpdates::UpdateService do
  let(:sprint) { create(:sprint) }
  let(:team) { create(:team) }
  let!(:update) { create(:draft_sprint_update, team: team, sprint: sprint) }
  let(:form_class) { SprintUpdates::DeliveryStatusForm }

  describe '#build' do
    subject do
      described_class.build(
        team_id: team.id,
        sprint_id: sprint.id,
        form_class: form_class
      )
    end

    context 'when the team is active for the sprint' do
      let(:team) { create(:team, start_on: sprint.start_on) }

      it 'is successful' do
        expect(subject).to be_success
      end
    end

    context 'when the team is not active for the sprint' do
      let(:team) { create(:team, start_on: sprint.end_on + 2.weeks) }

      it 'fails' do
        expect(subject).to be_failure
      end
    end

    context 'when the update is published' do
      let(:update) { create(:published_sprint_update, team: team, sprint: sprint) }

      it 'fails' do
        expect(subject).to be_failure
      end
    end
  end
end
