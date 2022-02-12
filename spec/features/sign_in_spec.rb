require 'rails_helper'

RSpec.describe 'signing in', type: :feature do
  before(:each) do
    create(:sprint)
  end

  describe 'when a user is signed out' do
    it 'can sign in and out', :skip_login do
      email = build(:invitation).email

      visit root_path
      fill_in 'email', with: email
      click_on 'Send me a link'

      invitation = Invitation.first

      visit redeem_invitation_path(invitation.token)

      click_on 'Sign me in'
      expect(page).to have_content("Signed in as #{invitation.email}", normalize_ws: true)

      click_on 'Sign out'
      expect(page).to have_content('Sign in')
    end
  end
end
