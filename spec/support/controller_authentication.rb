module ControllerAuthentication
  def sign_in(user)
    @request.session[:user_id] = user.id
  end
end

RSpec.configure do |config|
  config.include ControllerAuthentication, type: :controller

  config.before(:each, type: :controller) do |example|
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
