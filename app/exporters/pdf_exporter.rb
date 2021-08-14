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
                                  })
  end

  def body
    renderer.render(
      template: 'sprints/show',
      layout: 'layouts/pdf',
      formats: [:pdf],
      locals: {
        sprint: sprint,
        groups: groups,
      },
    )
  end

  def footer
    renderer.render(
      template: 'sprints/pdf/_footer',
      layout: 'pdf',
    )
  end

  def render_to_file
    File.open(output_file, 'wb') do |f|
      f << render
    end
  end

  def self.stylesheet
    manifest_url = "http://#{asset_host}/packs/manifest.json"
    stylesheet_file = 'pdf.css'

    manifest = JSON.parse(
      URI.parse(manifest_url).read,
    )

    stylesheet_path = manifest[stylesheet_file]
    stylesheet_url = "http://#{asset_host}#{stylesheet_path}"

    body = URI.parse(stylesheet_url).read

    "<style type=\"text/css\">#{body}</style>".html_safe
  end

  def self.asset_host
    if Rails.env.development?
      wds = Webpacker.dev_server
      "#{wds.host}:#{wds.port}"
    else
      Rails.application.config.action_controller.asset_host
    end
  end

  private

  attr_reader :sprint, :debug, :output_file, :doc

  def groups
    @groups ||= Group.in_order.with_teams.all
  end

  def renderer
    ApplicationController.renderer
  end
end
