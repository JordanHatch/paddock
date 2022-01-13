class Quarters::RootController < Quarters::BaseController
  def index
    redirect_to quarter_path(quarters.first) if quarters.any?
  end

  def show; end

  private

  helper_method :quarters, :commitments

  def quarters
    @quarters ||= Quarter.all
  end

  def commitments
    quarter.commitments.in_order
  end
end
