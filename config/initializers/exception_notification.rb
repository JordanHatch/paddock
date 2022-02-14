if ENV['EXCEPTION_NOTIFIER_ACTIVE'].present?
  paddock_env = ENV.fetch('PADDOCK_ENV', 'None')
  from = ENV.fetch('EXCEPTION_NOTIFIER_FROM', 'paddock@localhost')
  to = ENV.fetch('EXCEPTION_NOTIFIER_TO', '').split(',')

  Rails.application.config.middleware.use ExceptionNotification::Rack,
    email: {
      email_prefix: "[Paddock (#{paddock_env})] ",
      sender_address: %{"Paddock Exceptions" <#{from}>},
      exception_recipients: to,
      email_format: :html,
      sections: %w{request backtrace},
    },
    error_grouping: true,
    ignore_exceptions: ['ActionController::UnknownHttpMethod'] + ExceptionNotifier.ignored_exceptions
end
