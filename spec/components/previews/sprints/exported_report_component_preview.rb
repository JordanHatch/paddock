# @label Exported sprint report
#
class Sprints::ExportedReportComponentPreview < ViewComponent::Preview
  # @label Default
  # ----------------
  #
  # @display bg_color "#fff"
  def default
    render Sprints::ExportedReportComponent.new(
      report: ExportedSprintReport.new(
        created_at: 2.minutes.ago,
        user: User.new(email: 'example@example.org'),
      ),
    )
  end
end
