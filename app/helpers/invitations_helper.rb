module InvitationsHelper
  def invitation_user_initials(email)
    mailbox = email.split('@').first

    initials = mailbox.split('.').map do |string|
      string[0]
    end

    initials.join[0, 2].upcase
  end
end
