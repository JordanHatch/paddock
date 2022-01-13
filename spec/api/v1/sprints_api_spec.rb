require 'rails_helper'

RSpec.describe 'API V1 Sprints', type: :request, authenticate_api: true do
  describe 'fetching all sprints' do
    let!(:sprints) { create_list(:sprint, 5) }

    it 'returns a list of sprints' do
      get '/api/v1/sprints', headers: default_headers
      expect(response).to have_http_status(200)

      body = JSON.parse(response.body)

      expect(body['total']).to eq(sprints.count)
      expect(body['results_per_page']).to eq(20)
      expect(body['current_page']).to eq(1)
      expect(body['total_pages']).to eq(1)

      result = body['results'][0]
      expected = sprints[0]

      expect(result['id']).to eq(expected.id)
      expect(result['name']).to eq(expected.name)
      expect(Date.parse(result['start_on'])).to eq(expected.start_on)
      expect(Date.parse(result['end_on'])).to eq(expected.end_on)
    end

    it 'paginates results' do
      get '/api/v1/sprints?per_page=2', headers: default_headers
      expect(response).to have_http_status(200)

      body = JSON.parse(response.body)

      expect(body['total']).to eq(sprints.count)
      expect(body['results_per_page']).to eq(2)
      expect(body['current_page']).to eq(1)
      expect(body['total_pages']).to eq(3)

      expect(body['rel']['prev']).to be_nil

      next_page_url = body['rel']['next']
      expect(next_page_url).to match(/\/api\/v1\/sprints\?page=2&per_page=2$/)

      get next_page_url, headers: default_headers
      body = JSON.parse(response.body)

      expect(response).to have_http_status(200)

      expect(body['total']).to eq(sprints.count)
      expect(body['results_per_page']).to eq(2)
      expect(body['current_page']).to eq(2)
      expect(body['total_pages']).to eq(3)

      expect(body['rel']['prev']).to match(/\/api\/v1\/sprints\?per_page=2$/)
    end
  end

  describe 'requesting a single sprint' do
    let!(:sprint) { create(:sprint) }

    it 'returns the sprint' do
      get "/api/v1/sprints/#{sprint.id}", headers: default_headers
      expect(response).to have_http_status(200)

      body = JSON.parse(response.body)

      expect(body['id']).to eq(sprint.id)
      expect(body['name']).to eq(sprint.name)
      expect(Date.parse(body['start_on'])).to eq(sprint.start_on)
      expect(Date.parse(body['end_on'])).to eq(sprint.end_on)
    end
  end
end
