class QuarterNavigationPresenter
  def initialize(context, quarter:)
    @context = context
    @quarter = quarter
  end

  def next_quarter
    quarter.next_quarter
  end

  def previous_quarter
    quarter.previous_quarter
  end

  def link_to_previous_quarter?
    previous_quarter_exists?
  end

  def link_to_next_quarter?
    next_quarter_exists?
  end

  def quarter_start_on
    quarter.start_on.strftime('%b %e')
  end

  def quarter_end_on
    quarter.end_on.strftime('%b %e %Y')
  end

  def next_quarter_link
    quarter_navigation_path(next_quarter)
  end

  def previous_quarter_link
    quarter_navigation_path(previous_quarter)
  end

  private

  attr_reader :context, :quarter

  def previous_quarter_exists?
    previous_quarter.present?
  end

  def next_quarter_exists?
    next_quarter.present?
  end

  def quarter_navigation_path(quarter)
    context.quarter_path(quarter)
  end
end
