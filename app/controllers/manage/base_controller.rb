class Manage::BaseController < ApplicationController
  before_action :authorize_admin_user!

  layout 'manage'

  private

  def authorize_admin_user!
    unless signed_in_user.present? && signed_in_user.admin?
      raise ActionController::RoutingError.new('Not Found')
    end
  end
end
