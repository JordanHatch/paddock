class ApplicationController < ActionController::Base
  before_action :authenticate!
  before_action :set_paper_trail_whodunnit

  rescue_from ActionController::RoutingError, with: :render_404
  rescue_from ActiveRecord::RecordNotFound, with: :render_404

  private

  helper_method :signed_in?, :signed_in_admin?, :signed_in_user

  def signed_in?
    session[:user_id].present?
  end

  def signed_in_user
    @signed_in_user ||= User.find(session[:user_id]) if session[:user_id].present?
  end

  def signed_in_admin?
    signed_in_user.present? &&
      signed_in_user.admin?
  end

  def current_user
    signed_in_user
  end

  def authenticate!
    redirect_to new_invitation_path unless signed_in?
  end

  def render_404
    render file: "#{Rails.root}/public/404.html", status: :not_found, layout: false
  end
end
