source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.1'

gem 'rails', '~> 6.1.4'
gem 'pg'
gem 'puma', '~> 5.0'
gem 'webpacker', '~> 5.0'
gem 'jbuilder', '~> 2.7'
gem 'haml'
gem 'redcarpet'
gem 'simple_form'
gem 'enumerize'
gem 'friendly_id', '~> 5.4.0'
gem 'aasm'
gem 'after_commit_everywhere', '~> 1.0.0'
gem 'good_job'
gem 'premailer-rails'
gem 'paper_trail'
gem 'wicked_pdf'
gem 'wkhtmltopdf-binary'

gem 'dry-schema'
gem 'dry-struct'
gem 'dry-types'
gem 'dry-validation'

gem 'bootsnap', '>= 1.4.4', require: false

group :development, :test do
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'dotenv-rails'
  gem 'foreman'
  gem 'database_cleaner-active_record'
  gem 'rspec-rails'
  gem 'factory_bot_rails'
  gem 'mocha'
  gem 'capybara'
  gem 'simplecov', require: false
  gem 'cuprite'
end

group :development do
  gem 'web-console', '>= 4.1.0'
  gem 'rack-mini-profiler', '~> 2.0'
  gem 'listen', '~> 3.3'
  gem 'spring'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
