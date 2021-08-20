module InvitationsHelper

  def invitation_user_initials(email)
    mailbox = email.split('@').first

    initials = mailbox.split('.').map {
      |string| string[0]
    }

    initials.join[0,2].upcase
  end

end
