RSpec.configure do |config|
  config.include FactoryBot::Syntax::Methods

  config.before(:each) do |example|
    FactoryBot.rewind_sequences
  end
end
