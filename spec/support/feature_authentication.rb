module FeatureAuthentication
  def sign_in(_user, js: false)
    invitation = create(:invitation, email: @user.email)

    visit redeem_invitation_path(invitation.token)

    click_on 'Sign me in' unless js
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

      sign_in(@user, js: example.metadata[:js])
    end
  end
end
