class InvitationMailerPreview < ActionMailer::Preview
  def invitation_email
    InvitationMailer.with(email: 'test@awe.gov.au', token: 'foo').invitation_email
  end
end
