require 'rails_helper'

RSpec.describe SprintUpdates::BuildUpdateService do

  let(:sprint) { create(:sprint) }
  let(:team) { create(:team) }
  let(:update) { create(:draft_sprint_update, team: team, sprint: sprint) }
  let(:form_class) { SprintUpdates::DeliveryStatusForm }

  subject {
    described_class.call(
      team_id: team.id,
      sprint_id: sprint.id,
      form_class: form_class,
    )
  }

  describe '#call' do
    context 'when the team is not active for the sprint' do
      let(:team) { create(:team, start_on: sprint.end_on + 2.weeks) }

      it 'is not successful' do
        expect(subject).to be_failure
      end
    end

    context 'when the team is active for the sprint' do
      let(:team) { create(:team, start_on: sprint.start_on) }

      it 'is not successful' do
        expect(subject).to be_success
      end
    end
  end
end
