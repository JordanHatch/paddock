# @label Quarter navigation
class Quarters::QuarterNavigationComponentPreview < ViewComponent::Preview
  # @label Default
  # ----------------
  #
  # @display bg_color "#6a8892"
  def default
    render(Quarters::QuarterNavigationComponent.new(quarter: quarter,
                                                    previous_quarter: quarter,
                                                    next_quarter: quarter,
                                                    controller_name: 'quarters',
                                                    action_name: 'show'))
  end

  private

  def quarter
    Quarter.new(id: 1, start_on: Date.today, end_on: Date.today + 3.months)
  end
end
