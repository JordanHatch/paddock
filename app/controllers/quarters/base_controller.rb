class Quarters::BaseController < ApplicationController
  layout 'sections/quarters'

  private

  helper_method :quarter

  def quarter_id
    params.key?(:quarter_id) ? params[:quarter_id] : params[:id]
  end

  def quarter
    if quarter_id.present?
      @quarter ||= Quarter.friendly.includes(:commitments).find(quarter_id)
    end
  end
end
