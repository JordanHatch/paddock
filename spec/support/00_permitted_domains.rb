RSpec.configure do |config|
  config.before(:each) do |example|
    Paddock.permitted_domains = 'example.org' unless example.metadata[:skip_permitted_domains]
  end
end
