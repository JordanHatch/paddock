module FeatureAuthentication
  def sign_in(user, js: false)
    invitation = create(:invitation, email: @user.email)

    visit redeem_invitation_path(invitation.token)

    unless js
      click_on 'Sign me in'
    end
  end
end

RSpec.configure do |config|
  config.include FeatureAuthentication, type: :feature

  config.before(:each, type: :feature) do |example|
    unless example.metadata[:skip_login]
      @user = example.metadata[:admin_user] ?
        create(:admin_user) :
        create(:user)

      sign_in(@user, js: example.metadata[:js])
    end
  end
end
