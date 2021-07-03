require 'capybara/apparition'

Capybara.register_driver :apparition do |app|
  Capybara::Apparition::Driver.new(app, {
    headless: true,
  })
end

Capybara.javascript_driver = :apparition
Capybara.default_max_wait_time = 5
