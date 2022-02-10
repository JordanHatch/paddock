class PdfExporter
  def initialize(sprint_id:, output_file: nil, debug: false)
    @sprint = Sprint.find(sprint_id)
    @output_file = output_file
    @debug = debug
  end

  def render
    return body if debug

    WickedPdf.new.pdf_from_string(body,
                                  margin: {
                                    top: 0,
                                    bottom: 20,
                                    left: 0,
                                    right: 0,
                                  },
                                  footer: {
                                    content: footer,
                                    line: false,
                                    spacing: 0,
                                  },
                                  outline: {
                                    outline_depth: 2,
                                  })
  end

  def body
    renderer.render(
      template: 'report',
      layout: '_layout',
      formats: [:pdf],
      locals: {
        sprint: sprint,
        groups: groups,
        views_path: views_path,
      },
    )
  end

  def footer
    renderer.render(
      template: '_footer',
      layout: '_layout',
    )
  end

  def render_to_file
    File.open(output_file, 'wb') do |f|
      f << render
    end
  end

  def self.stylesheet
    assets = Rails.application.assets

    stylesheet = assets.load_path.find('pdf.css')
    body = assets.compilers.compile(stylesheet).force_encoding('UTF-8')

    "<style type=\"text/css\">#{body}</style>".html_safe
  end

  private

  attr_reader :sprint, :debug, :output_file, :doc

  def groups
    @groups ||= Group.in_order.with_teams.all
  end

  def renderer
    ApplicationController.prepend_view_path(views_path)
    ApplicationController.renderer
  end

  def views_path
    'app/views/exporters/pdf'
  end
end
