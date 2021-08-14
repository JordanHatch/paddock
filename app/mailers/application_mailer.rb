class ApplicationMailer < ActionMailer::Base
  class << self
    def sender_name
      environment = ENV['PADDOCK_ENV']

      show_env = environment.present? && environment != 'production'
      str = show_env ? " (#{environment})" : nil

      "Paddock#{str}"
    end
  end

  default from: "\"#{sender_name}\" <#{ENV.fetch('EMAIL_FROM_ADDRESS')}>"
  layout 'mailer'
end
