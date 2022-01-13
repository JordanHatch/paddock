require 'rails_helper'

RSpec.describe 'API V1 Sprint Updates', type: :request, authenticate_api: true do
  describe 'fetching all sprint updates' do
    let!(:sprint_updates) { create_list(:published_sprint_update, 5) }
    let!(:issue) { create(:issue, sprint_update: sprint_updates[0]) }

    it 'returns a list of sprint updates' do
      get '/api/v1/sprint-updates', headers: default_headers
      expect(response).to have_http_status(200)

      body = JSON.parse(response.body)

      expect(body['total']).to eq(sprint_updates.count)
      expect(body['results_per_page']).to eq(20)
      expect(body['current_page']).to eq(1)
      expect(body['total_pages']).to eq(1)

      result = body['results'][0]
      expected = sprint_updates[0]

      expect(result['id']).to eq(expected.id)
      expect(result['url']).to match(/sprints\/#{expected.sprint_id}\/#{expected.team.friendly_id}$/)

      expect(result['team']['id']).to eq(expected.team_id)
      expect(result['sprint']['id']).to eq(expected.sprint_id)
      expect(result['group']['id']).to eq(expected.group.id)

      expect(result['issues'][0]['id']).to eq(expected.issues[0].id)
    end

    it 'excludes non-published updates' do
      create_list(:draft_sprint_update, 3)
      create_list(:not_started_sprint_update, 3)

      get '/api/v1/sprint-updates', headers: default_headers
      expect(response).to have_http_status(200)

      body = JSON.parse(response.body)

      expect(body['total']).to eq(sprint_updates.count)
    end
  end

  describe 'filtering updates by sprint' do
    let!(:sprint) { create(:sprint) }
    let!(:matching_updates) { create_list(:published_sprint_update, 3, sprint: sprint) }
    let!(:not_matching_updates) { create_list(:published_sprint_update, 2) }

    it 'returns all updates without a filter' do
      get '/api/v1/sprint-updates', headers: default_headers

      body = JSON.parse(response.body)
      expect(body['total']).to eq(5)
    end

    it 'returns only matching updates given a sprint parameter' do
      get "/api/v1/sprint-updates?sprint=#{sprint.id}", headers: default_headers

      body = JSON.parse(response.body)
      expect(body['total']).to eq(3)
    end
  end

  describe 'requesting a single sprint update' do
    let!(:sprint_update) { create(:published_sprint_update) }
    let!(:issue) { create(:issue, sprint_update: sprint_update) }

    it 'returns the sprint' do
      get "/api/v1/sprint-updates/#{sprint_update.id}", headers: default_headers
      expect(response).to have_http_status(200)

      body = JSON.parse(response.body)

      expect(body['id']).to eq(sprint_update.id)
      expect(body['url']).to match(/sprints\/#{sprint_update.sprint_id}\/#{sprint_update.team.friendly_id}$/)

      expect(body['team']['id']).to eq(sprint_update.team_id)
      expect(body['sprint']['id']).to eq(sprint_update.sprint_id)
      expect(body['group']['id']).to eq(sprint_update.group.id)

      expect(body['issues'][0]['id']).to eq(sprint_update.issues[0].id)
    end

    it 'only returns published updates' do
      not_started_update = create(:not_started_sprint_update)
      get "/api/v1/sprint-updates/#{not_started_update.id}", headers: default_headers

      expect(response).to have_http_status(404)

      draft_update = create(:draft_sprint_update)
      get "/api/v1/sprint-updates/#{draft_update.id}", headers: default_headers

      expect(response).to have_http_status(404)
    end
  end
end
