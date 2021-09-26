require 'rails_helper'

RSpec.describe 'API V1 Authentication', type: :request do

  context 'with an OAuth application created' do
    let!(:application) {
      Doorkeeper::Application.create!(name: 'Test', scopes: %w(read))
    }
    let(:client_id) { application.uid }
    let(:client_secret) { application.secret }

    it 'can request an access token and use it to make an API request' do
      post '/oauth/token', params: {
        grant_type: 'client_credentials',
        client_id: client_id,
        client_secret: client_secret,
      }

      body = JSON.parse(response.body)

      expect(body['access_token']).to be_present
      expect(body['token_type']).to eq('Bearer')
      expect(body['scope']).to eq('read')

      get '/api/v1/sprints', headers: {
                               'Authorization' => "Bearer #{body['access_token']}",
                             }

      expect(response).to have_http_status(200)
    end
  end

  context 'without an access token' do
    it 'returns a 401 Unauthorized response' do
      get '/api/v1/sprints'
      expect(response).to have_http_status(401)
    end
  end

  context 'with an invalid access token' do
    it 'returns a 401 Unauthorized response' do
      get '/api/v1/sprints', headers: {
                               'Authorization' => "Bearer Foo",
                             }
      expect(response).to have_http_status(401)
    end
  end

end
