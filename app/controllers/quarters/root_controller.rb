class Quarters::RootController < Quarters::BaseController
  def index
    if current_quarter.present?
      redirect_to quarter_path(current_quarter)
    elsif quarters.any?
      redirect_to quarter_path(quarters.first)
    end
  end

  def show; end

  private

  helper_method :quarters, :key_commitments, :sprints

  def current_quarter
    Quarter.current
  end

  def quarters
    @quarters ||= Quarter.all
  end

  def key_commitments
    @key_commitments ||= quarter.key_commitments.in_order
  end

  def sprints
    @sprints ||= Sprint.for_quarter(quarter).in_date_order
  end
end
