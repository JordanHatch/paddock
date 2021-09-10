class Manage::BaseController < ApplicationController
  before_action :authorize_admin_user!

  layout 'manage'

  private

  def authorize_admin_user!
    raise ActionController::RoutingError, 'Not Found' unless signed_in_admin?
  end
end
