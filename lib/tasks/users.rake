require 'optparse'

namespace :users do
  task make_admin: :environment do |_t|
    options = {}
    parser = OptionParser.new do |opts|
      opts.banner = 'Usage: rake users:make_admin -- [options]'

      opts.on('--email=EMAIL', 'Email address of the target user', String) do |email|
        options[:email] = email
      end
    end

    # rubocop:disable Lint/EmptyBlock
    parser.parse!(parser.order!(ARGV) {})
    # rubocop:enable Lint/EmptyBlock

    if options[:email].blank?
      puts parser.help
      exit
    end

    puts "  ---> Set role to 'admin' for user: #{options[:email]}"

    user = User.find_by!(email: options[:email])
    user.role = :admin
    user.save!

    puts '       Completed'
  end
end
