require 'optparse'

namespace :oauth do
  namespace :applications do
    task create: :environment do |_t|
      options = {}
      parser = OptionParser.new do |opts|
        opts.banner = 'Usage: rake oauth:applications:create -- [options]'

        opts.on('--name=NAME', 'Name of the application', String) do |name|
          options[:name] = name
        end
      end

      # rubocop:disable Lint/EmptyBlock
      parser.parse!(parser.order!(ARGV) {})
      # rubocop:enable Lint/EmptyBlock

      if options[:name].blank?
        puts parser.help
        exit
      end

      puts "  ---> Create OAuth application: #{options[:name]}"

      app = Doorkeeper::Application.create!(name: options[:name])

      puts "       Completed\n\n"
      puts "       Client ID:     #{app.uid}"
      puts "       Client Secret: #{app.secret}\n\n"
    end

    task list: :environment do |_t|
      puts "  ---> List all OAuth applications"

      Doorkeeper::Application.all.each do |app|
        puts "-------------------------------------"
        puts "ID: #{app.id}"
        puts "Name: #{app.name}"
        puts "-------------------------------------\n"
      end
    end

    task delete: :environment do |_t|
      options = {}
      parser = OptionParser.new do |opts|
        opts.banner = 'Usage: rake oauth:applications:delete -- [options]'

        opts.on('--id=ID', 'ID of the application', String) do |id|
          options[:id] = id
        end
      end

      # rubocop:disable Lint/EmptyBlock
      parser.parse!(parser.order!(ARGV) {})
      # rubocop:enable Lint/EmptyBlock

      if options[:id].blank?
        puts parser.help
        exit
      end

      puts "  ---> Delete OAuth application: #{options[:id]}"

      app = Doorkeeper::Application.find(options[:id])
      app.destroy

      puts "       Completed\n\n"
    end
  end
end
