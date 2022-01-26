require 'rails_helper'

RSpec.describe PdfExporter do
  let!(:sprint) { create(:sprint) }
  let!(:teams) { create_list(:team, 3, start_on: sprint.start_on) }
  let!(:updates) do
    [
      create(:draft_sprint_update, sprint: sprint, team: teams[0]),
      create(:published_sprint_update, sprint: sprint, team: teams[1]),
      create(:published_sprint_update, sprint: sprint, team: teams[2]),
    ]
  end

  let(:example_stylesheet) { '<!-- example stylesheet -->' }

  def stub_stylesheet
    PdfExporter.stubs(:stylesheet).returns(example_stylesheet)
  end

  describe '#body' do
    before(:each) { stub_stylesheet }

    it 'renders the body' do
      exporter = described_class.new(sprint_id: sprint.id)
      pdf = Capybara.string(exporter.body)

      expect(pdf).to have_content('Sprint report')
      expect(pdf).to have_content(example_stylesheet)
    end

    it 'only displays teams for the current sprint' do
      current_sprint = create(:sprint, end_on: Date.today)
      included_teams = create_list(:team, 3, start_on: 2.days.ago)
      excluded_teams = create_list(:team, 3, start_on: 2.days.from_now)

      exporter = described_class.new(
        sprint_id: current_sprint.id,
        debug: true,
      )
      pdf = Capybara.string(exporter.body)

      groups = pdf.find('ul.groups')

      included_teams.each do |team|
        expect(groups).to have_content(team.name)
      end

      excluded_teams.each do |team|
        expect(groups).to_not have_content(team.name)
      end
    end
  end

  describe '#render' do
    let(:body) { 'example content' }

    before(:each) do
      stub_stylesheet
      subject.stubs(:body).returns(body)
    end

    context 'when debug is true' do
      subject do
        described_class.new(sprint_id: sprint.id, debug: true)
      end

      it 'returns the body as rendered HTML' do
        expect(subject.render).to eq(body)
      end
    end

    context 'when debug is not true' do
      subject do
        described_class.new(sprint_id: sprint.id)
      end

      it 'renders the PDF using WickedPdf' do
        mock_wicked_pdf = mock
        mock_pdf_output = mock

        WickedPdf.expects(:new).returns(mock_wicked_pdf)
        mock_wicked_pdf.expects(:pdf_from_string)
                       .with(body, has_keys(:margin, :footer))
                       .returns(mock_pdf_output)

        expect(subject.render).to eq(mock_pdf_output)
      end
    end
  end

  describe '#footer' do
    before(:each) { stub_stylesheet }

    it 'renders the footer' do
      exporter = described_class.new(sprint_id: sprint.id)
      pdf = Capybara.string(exporter.footer)

      expect(pdf).to have_content('Generated at')
      expect(pdf).to have_content(example_stylesheet)
    end
  end

  describe '.stylesheet' do
    it 'renders the compiled PDF stylesheet and returns it inline' do
      stylesheet = 'body { color: red; }'
      mock_asset = mock()

      Rails.application.assets.load_path.expects(:find).with('pdf.css').returns(mock_asset)
      Rails.application.assets.compilers.expects(:compile).with(mock_asset).returns(stylesheet)

      expected = '<style type="text/css">body { color: red; }</style>'

      expect(described_class.stylesheet).to eq(expected)
    end
  end
end
