module FeatureAuthentication
  def sign_in(user)
    invitation = create(:invitation, email: user.email)

    visit redeem_invitation_path(invitation.token)

    click_on 'Sign me in'

    expect(page).to have_content("Signed in as #{user.email}")
  end
end

RSpec.configure do |config|
  config.include FeatureAuthentication, type: :feature

  config.before(:each, type: :feature) do |example|
    unless example.metadata[:skip_login]
      @user = if example.metadata[:admin_user]
                create(:admin_user)
              else
                create(:user)
              end

      sign_in(@user)
    end
  end
end
