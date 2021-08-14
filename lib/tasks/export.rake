require 'optparse'

namespace :export do
  task pdf: :environment do |_t|
    options = {}
    parser = OptionParser.new do |opts|
      opts.banner = 'Usage: rake export:pdf [options]'

      opts.on('-sID', '--sprint=ID', Integer) do |sprint|
        options[:sprint] = sprint
      end

      opts.on('-fFILE', '--file=FILE', String) do |file|
        options[:file] = file
      end
    end

    parser.parse!(parser.order!(ARGV) {})

    exporter = PdfExporter.new(
      sprint_id: options[:sprint],
      output_file: options[:file]
    )
    exporter.render_to_file
  end
end
