class ExportSprintReportJob < ApplicationJob
  queue_as :default

  def perform(report)
    filename = Rails.root.join("tmp/sprint_report_#{Time.now.to_i}_#{Random.rand(1000)}.pdf")

    PdfExporter.new(sprint_id: report.sprint.id, output_file: filename).render_to_file

    report.file.attach(io: File.open(filename),
                       filename: 'report.pdf',
                       content_type: 'application/pdf')

    File.delete(filename)
  end
end
