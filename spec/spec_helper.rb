# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'

require File.expand_path('../config/environment', __dir__)
require 'rspec/rails'
require 'rspec/autorun'
require 'cancan/matchers'
# require 'sidekiq/testing'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

RSpec.configure do |config|
  # ## Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # If true, the base class of anonymous controllers will be inferred
  # automatically. This will be the default behavior in future versions of
  # rspec-rails.
  config.infer_base_class_for_anonymous_controllers = false

  # Run specs in random order to surface order dependencies. If you find an
  # order dependency and want to debug it, you can fix the order by providing
  # the seed, which is printed after each run.
  #     --seed 1234
  config.order = 'random'

  config.render_views

  config.include Devise::Test::ControllerHelpers, type: :helper
  config.include Devise::Test::ControllerHelpers, type: :controller

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation, { except: %w[spatial_ref_sys] }
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  # NOTE: (cmhobbs) opt into automatic inference of an example group's spec
  #      type.  this provides some backwards compat with older specs in s2p
  #      that came in before rspec-rails > v3
  RSpec.configure do |config|
    config.infer_spec_type_from_file_location!
  end

  # Include our API tests
  config.include RSpec::Rails::RequestExampleGroup, type: :request, example_group: {
    file_path: %r{spec/api}
  }

  RSpec::Sidekiq.configure do |config|
    # Clears all job queues before each example
    config.clear_all_enqueued_jobs = true # default => true

    # Whether to use terminal colours when outputting messages
    config.enable_terminal_colours = true # default => true

    # Warn when jobs are not enqueued to Redis but to a job array
    config.warn_when_jobs_not_processed_by_sidekiq = true # default => true
  end
end
