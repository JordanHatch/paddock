require_relative "boot"

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_mailbox/engine"
require "action_text/engine"
require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Paddock
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    config.action_mailer.delivery_method = :smtp
    config.action_mailer.default_url_options = {
      host: ENV['EMAIL_URL_HOST'],
      port: ENV.fetch('EMAIL_URL_PORT', 80),
      protocol: ENV['EMAIL_URL_HOST_SSL'] == 'true' ? :https : :http,
    }
    config.action_mailer.smtp_settings = {
      user_name: ENV['SMTP_USERNAME'],
      password: ENV['SMTP_PASSWORD'],
      domain: ENV['SMTP_DOMAIN'],
      address: ENV['SMTP_HOST'],
      port: ENV.fetch('SMTP_PORT', '587'),
      authentication: :plain,
      enable_starttls_auto: true,
    }

    if ENV['ASSET_HOST'].present?
      config.action_controller.asset_host = ENV['ASSET_HOST']
    end

    config.active_job.queue_adapter = :good_job

    # Don't generate system test files.
    config.generators.system_tests = nil
  end
end
