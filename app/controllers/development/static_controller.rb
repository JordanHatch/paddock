class Development::StaticController < ApplicationController
  def show
    render action: params[:view]
  end
end
