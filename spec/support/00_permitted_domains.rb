RSpec.configure do |config|
  config.before(:each) do |example|
    unless example.metadata[:skip_permitted_domains]
      Paddock.permitted_domains = 'example.org'
    end
  end
end
