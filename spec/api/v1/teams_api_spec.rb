require 'rails_helper'

RSpec.describe 'API V1 Teams', type: :request, authenticate_api: true do

  describe 'fetching all teams' do
    let!(:teams) { create_list(:team, 5) }

    it 'returns a list of teams' do
      get '/api/v1/teams', headers: default_headers
      expect(response).to have_http_status(200)

      body = JSON.parse(response.body)

      expect(body['total']).to eq(teams.count)
      expect(body['results_per_page']).to eq(20)
      expect(body['current_page']).to eq(1)
      expect(body['total_pages']).to eq(1)

      result = body['results'][0]
      expected = teams[0]

      expect(result['id']).to eq(expected.id)
      expect(result['name']).to eq(expected.name)
      expect(result['slug']).to eq(expected.friendly_id)
      expect(Date.parse(result['start_on'])).to eq(expected.start_on)

      expect(result['group']['id']).to eq(expected.group_id)
      expect(result['group']['name']).to eq(expected.group.name)
    end
  end

  describe 'requesting a single team' do
    let!(:team) { create(:team) }

    it 'returns the team' do
      get "/api/v1/teams/#{team.id}", headers: default_headers
      expect(response).to have_http_status(200)

      body = JSON.parse(response.body)

      expect(body['id']).to eq(team.id)
      expect(body['name']).to eq(team.name)
      expect(body['slug']).to eq(team.friendly_id)
      expect(Date.parse(body['start_on'])).to eq(team.start_on)

      expect(body['group']['id']).to eq(team.group_id)
      expect(body['group']['name']).to eq(team.group.name)
    end
  end

end
