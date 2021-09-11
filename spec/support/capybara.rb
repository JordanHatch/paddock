require 'capybara/cuprite'

Capybara.javascript_driver = :cuprite
Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(app, headless: true, timeout: 10)
end

Capybara.default_max_wait_time = 10

# This allows Capybara to interact with our custom checkbox and radio button
# components, where the <input> is hidden and the <label> tag includes the
# visible control.
#
Capybara.automatic_label_click = true
