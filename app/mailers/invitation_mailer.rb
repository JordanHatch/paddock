class InvitationMailer < ApplicationMailer
  def invitation_email
    @email = params[:email]
    @token = params[:token]

    mail(to: @email, subject: 'Your magic sign-in link')
  end
end
