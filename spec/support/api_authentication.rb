module APIAuthentication
  def get_access_token
    @application = Doorkeeper::Application.create!(name: 'Test', scopes: %w[read])
    @client_id = @application.uid
    @client_secret = @application.secret

    post '/oauth/token', params: {
      grant_type: 'client_credentials',
      client_id: @client_id,
      client_secret: @client_secret,
    }

    JSON.parse(response.body)['access_token']
  end

  def default_headers
    {
      'Authorization' => "Bearer #{@access_token}",
    }
  end
end

RSpec.configure do |config|
  config.include APIAuthentication, type: :request

  config.before(:each, type: :request) do |example|
    @access_token = get_access_token if example.metadata[:authenticate_api]
  end
end
