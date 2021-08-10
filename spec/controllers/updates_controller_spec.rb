require 'rails_helper'

RSpec.describe UpdatesController, type: :controller do

  let(:sprint) { create(:sprint) }

  describe 'GET show' do
    render_views

    context 'for an active team' do
      let(:team) { create(:team, start_on: sprint.start_on) }

      it 'assigns the sprint and team' do
        get :show, params: { sprint_id: sprint, team_id: team }

        expect(controller.send(:sprint)).to eq(sprint)
        expect(controller.send(:team)).to eq(team)
      end
    end

    context 'for an inactive team' do
      let(:team) { create(:team, start_on: sprint.end_on + 2.weeks) }

      it 'returns a not found error' do
        get :show, params: { sprint_id: sprint, team_id: team }

        expect(response.status).to eq(404)
      end
    end
  end

end
