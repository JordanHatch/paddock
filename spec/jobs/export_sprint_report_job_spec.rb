require 'rails_helper'

RSpec.describe ExportSprintReportJob do
  describe '#perform' do
    let(:sprint) { create(:sprint) }
    let(:report) { create(:exported_sprint_report, sprint: sprint) }

    subject { described_class.perform_now(report) }

    it 'renders the PDF to a temporary file' do
      time = Time.now
      random_number = 1234

      Random.stubs(:rand).with(1000).returns(random_number)

      mock_exporter = stub('PdfExporter')
      expected_filename = Rails.root.join("tmp/sprint_report_#{time.to_i}_#{random_number}.pdf")

      PdfExporter.expects(:new)
                 .with(sprint_id: sprint.id, output_file: expected_filename)
                 .returns(mock_exporter)
      mock_exporter.expects(:render_to_file)

      mock_file = stub('File')
      File.expects(:open).with(expected_filename).returns(mock_file)

      mock_attachment = stub
      report.expects(:file).returns(mock_attachment)
      mock_attachment.expects(:attach).with(has_entries(io: mock_file))

      File.expects(:delete).with(expected_filename)

      Timecop.freeze(time) do
        subject
      end
    end
  end
end
