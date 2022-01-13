class Quarters::BaseController < ApplicationController
  layout 'sections/quarters'

  private

  helper_method :quarter

  def quarter_id
    params.key?(:quarter_id) ? params[:quarter_id] : params[:id]
  end

  def quarter
    @quarter ||= Quarter.friendly.includes(:commitments).find(quarter_id) if quarter_id.present?
  end
end
