source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2'

# Use postgresql as the database for Active Record
gem 'pg'
gem 'devise'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.0'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 1.2'

gem 'slim-rails'
gem 'carrierwave'
gem 'remotipart'
gem 'cocoon'
gem 'private_pub'
gem 'thin'
gem 'responders'
gem 'omniauth'
gem 'letter_opener'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'capybara-email'
gem 'doorkeeper'
gem 'active_model_serializers'
gem 'oj'
gem 'oj_mimic_json'
gem 'cancancan'
# gem 'delayed_job_active_record'
gem 'whenever'
gem 'sidekiq'
gem 'sinatra', '>= 1.3.0', require: nil
gem 'sidetiq'
gem 'mysql2'
gem 'thinking-sphinx'
gem 'dotenv'
gem 'dotenv-deployment', require: 'dotenv/deployment'
gem 'unicorn'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  gem 'guard-rubocop'
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-sidekiq', require: false
  gem 'capistrano3-unicorn', require: false
end

group :test, :development do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'launchy'
  gem 'database_cleaner'
  gem 'capybara-webkit'
end

group :test do
  gem 'json_spec'
  gem "shoulda-matchers", "~> 3.1", require: false
end
