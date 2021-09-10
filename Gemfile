# frozen_string_literal: true

source 'https://rubygems.org'

ruby '2.6.6'

gem 'rails', '~> 4.2.11.3'

gem 'activerecord-postgis-adapter', '~> 3.1'
gem 'activerecord-postgresql-adapter', '~> 0.0'
gem 'activerecord-session_store', '~> 1.1'
gem 'attr_encrypted', '~> 1.3'

gem 'bootstrap-sass', '~> 2.3' # NOTE: (cmhobbs+tyreldenison) downgrade to resolve haml/css issues
gem 'brakeman', '~> 4.10', require: false
gem 'bundler', '1.17.3'

gem 'cancan', '~> 1.6'
gem 'carrierwave', '~> 1.3'
gem 'chartkick', '~> 3.4'
gem 'chosen-rails', '~> 1.9'
gem 'closure_tree', '~> 6.6'
gem 'coffee-rails', '~> 4.2'

gem 'bigdecimal', '~> 1.4.0'
gem 'databasedotcom', '~> 1.3'
gem 'decent_exposure', '~> 3.0'
gem 'devise', '~> 4.7', '>= 4.7.3'
gem 'devise_invitable', '~> 1.7'
gem 'devise_security_extension', '~> 0.9'
gem 'dynamic_sitemaps', '~> 2.0'

gem 'ejs', '~> 1.1'
gem 'encryptor', '~> 1.3'

gem 'fitter-happier', '~> 0.0'
gem 'flowdock', '~> 0.7'
gem 'fog', '~> 1.41'

gem 'geocoder', '~> 1.6'
gem 'gmapsjs', '~> 0.4'
gem 'grape', '~> 0.11'
gem 'groupdate', '~> 4.1'

gem 'haml', '~> 5.2', '>= 5.2.1' # NOTE: (conradwt) upgraded from gem 'haml', '~> 3.1'
gem 'headliner', '~> 0.1'
gem 'httparty', '~> 0.18'

gem 'icalendar', '~> 2.7'

gem 'jquery-rails', '~> 4.4'
gem 'jquery-ui-rails', '~> 6.0'

gem 'kgio', '~> 2.9' # NOTE: (cmhobbs+tyreldenison) downgrade to resolve deploys

gem 'libv8', '~> 8.4', '>= 8.4.255.0'
gem 'linkedin', '~> 1.1'

gem 'metamagic', '~> 3.1'
gem 'mini_magick', '~> 4.11'
gem 'mini_racer', '~> 0.3'

gem 'omniauth', '~> 1.9'
gem 'omniauth-linkedin', '~> 0.2'
gem 'omniauth-salesforce', git: 'https://github.com/mintotsai/omniauth-salesforce'

gem 'pg', '~> 0.21.0'
gem 'pg_search', '~> 2.3'
gem 'possessive', '~> 1.0'
gem 'prawn',   '~> 1.3.0'
gem 'prawn-table', '0.2.2'
gem 'puma', '~> 4.3.7'

gem 'rails3-jquery-autocomplete', '~> 1.0'
gem 'rails_email_validator', '~> 0.1'
gem 'rake', '~> 13.0'
gem 'redcarpet', '~> 3.5'
gem 'redis', '~> 3.3', require: 'redis'
gem 'responders', '~> 2.4'
gem 'resque', '~> 2.0'
gem 'restforce', '~> 5.0.3' # Note (conradwt) Required?
gem 'rgeo-activerecord', '~> 4.0'
gem 'rmagick', '~> 4.1.2'
gem 'role_model', '~> 0.8'

gem 'sanitize', '~> 5.2'
# gem 'sass', '~> 3.2' # NOTE (cmhobbs) attempt to line up gem versions, (conradwt) Required?
gem 'sass-rails', '~> 6.0'
gem 'sidekiq', '~> 2.12'
gem 'simple_form', '~> 4.0'
gem 'sinatra', '~> 1.4'
gem 'slim', '~> 4.1'
gem 'socialization', '~> 1.2'
gem 'state_machine', '~> 1.2'
gem 'stripe', '~> 5.28'

# gem 'therubyracer', '~> 0.12.3', platforms: :ruby # NOTE: (conradwt) Required?
gem 'time_diff', '~> 0.3'

gem 'uglifier', '~> 4.2'

gem 'whenever', '~> 1.0', require: false
gem 'will_paginate', '~> 3.3.0'

group :production do
  gem 'newrelic_rpm', '~> 6.14'

  gem 'unicorn', '~> 5.7'
end

group :development do
  gem 'annotate', '~> 3.1'

  # gem 'better_errors', '~> 0.6' # NOTE (conradwt) Required for Rails 4.2?
  # gem 'binding_of_caller', '~> 0.8' # NOTE (conradwt) Required for Rails 4.2?

  gem 'capistrano', '~> 3.14', require: false
  gem 'capistrano3-puma', '~> 5.0', '>= 5.0.1', require: false
  gem 'capistrano-bundler', '~> 2.0', require: false
  gem 'capistrano-rails', '~> 1.6', require: false
  gem 'capistrano-rvm', '~> 0.1', require: false
  gem 'capistrano-sidekiq', '~> 0.5'

  gem 'flay', '~> 2.12'
  gem 'flog', '~> 4.6'
  gem 'foreman', '~> 0.87'

  gem 'irbtools', '~> 1.7', require: false

  gem 'mailcatcher', '~> 0.2'

  gem 'nifty-generators', '~> 0.4'

  gem 'pry', '~> 0.13'
  gem 'pry-rails', '~> 0.3'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring', '~> 2.1', '>= 2.1.1'

  gem 'thin', '~> 1.8'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
end

group :test, :development do
  # NOTE: (cmhobbs) required for older s2p specs
  gem 'awesome_print', '~> 1.8'

  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', '~> 11.1', '>= 11.1.3'

  gem 'quiet_assets', '~> 1.1'

  gem 'rspec-activemodel-mocks', '~> 1.1'
  gem 'rspec-mocks', '~> 3.10'
  gem 'rspec-rails', '~> 4.0'
  gem 'rspec-sidekiq', '~> 3.1'
end

group :test do
  gem 'capybara', '~> 3.34'

  gem 'database_cleaner', '~> 1.8'

  gem 'factory_bot_rails', '~> 4.8'
  gem 'faker', '~> 2.2'

  gem 'mocha', '~> 1.11'

  gem 'vcr', '~> 2.9'

  gem 'webmock', '~> 3.10'
end

# FIXME: (cmhobbs) necessary for ruby 2+.
#       remove after rails $ upgrade
gem 'test-unit', '~> 3.3'
