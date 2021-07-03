class SendInvitationEmailJob < ApplicationJob
  queue_as :default

  def perform(invitation)
    InvitationMailer.with(email: invitation.email, token: invitation.token).invitation_email.deliver_now
  end
end
