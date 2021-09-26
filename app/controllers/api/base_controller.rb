class Api::BaseController < ApplicationController
  skip_before_action :authenticate!

  before_action :doorkeeper_authorize!
  before_action :set_format

  rescue_from ActionController::RoutingError, with: :head_404
  rescue_from ActiveRecord::RecordNotFound, with: :head_404

  private

  def set_format
    request.format = :json
  end

  def head_404
    head :not_found
  end
end
