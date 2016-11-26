source 'https://rubygems.org'

gem 'rails', '~> 5.0.0'
# Use sqlite3 as the database for Active Record
gem 'sqlite3'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.11'

# Use Unicorn as the app server
gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

gem 'bootstrap-sass'
gem 'd3_rails'

# a "hack" to stream video properly with send_file
gem 'send_file_with_range'

# my gems, pulled directly from my github
# (so I don't have to publish to rubygems.org)
gem 'pack_the_bin', git: 'https://github.com/davidyoung604/pack_the_bin.git'
gem 'tiff_parser', git: 'https://github.com/davidyoung604/tiff_parser.git'

group :development, :test do
  gem 'minitest'
  gem 'minitest-reporters'
  gem 'simplecov'
  gem 'rails-controller-testing'
end

group :test do
  gem 'codeclimate-test-reporter', '~> 1.0.0'
end

group :development do
  # Call 'byebug' anywhere in the code to get a debugger console
  gem 'byebug'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application
  # running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'benchmark-ips'
end
