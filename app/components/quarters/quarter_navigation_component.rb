class Quarters::QuarterNavigationComponent < BaseComponent
  option :quarter
  option :previous_quarter
  option :next_quarter

  option :controller_name, type: proc(&:to_s)
  option :action_name, type: proc(&:to_s)

  private

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

  def previous_quarter_exists?
    previous_quarter.present?
  end

  def next_quarter_exists?
    next_quarter.present?
  end

  def quarter_navigation_path(quarter)
    if controller_name == 'commitments' && action_name == 'index'
      quarter_commitments_path(quarter)
    else
      quarter_path(quarter)
    end
  end
end
