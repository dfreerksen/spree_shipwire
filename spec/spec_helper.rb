# Run Coverage report
require 'simplecov'
SimpleCov.start :rails do
  add_group 'Workers', 'app/workers'
end

# Configure Rails Environment
ENV['RAILS_ENV'] = 'test'

begin
  require File.expand_path('../dummy/config/environment.rb',  __FILE__)
rescue LoadError
  puts 'Could not load dummy application. Run `bundle exec rake test_app` first'
  exit
end

require 'rspec/rails'
require 'database_cleaner'
require 'ffaker'
require 'sidekiq/testing'
require 'rspec-sidekiq'
require 'capybara'
require 'capybara/rspec'
require 'capybara/rails'
require 'capybara/poltergeist'
require 'vcr'
require 'pry'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

# Requires factories and other useful helpers defined in spree_core.
require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/capybara_ext'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/factories'
require 'spree/testing_support/url_helpers'
require 'spree/testing_support/order_walkthrough'

Capybara.javascript_driver = :poltergeist

# VCR
VCR.configure do |c|
  c.hook_into :webmock
  c.cassette_library_dir = 'spec/support/vcr_cassettes'
  c.configure_rspec_metadata!
  c.default_cassette_options = { record: :new_episodes }
end

Sidekiq::Testing.fake!

RSpec::Sidekiq.configure do |config|
  config.warn_when_jobs_not_processed_by_sidekiq = false
end

RSpec.configure do |config|
  config.include Capybara::DSL
  config.include Spree::TestingSupport::ControllerRequests
  config.include FactoryGirl::Syntax::Methods
  config.include Spree::TestingSupport::UrlHelpers
  config.include Devise::TestHelpers, type: :controller

  config.deprecation_stream = 'rspec.log'

  # Infer an example group's spec type from the file location.
  config.infer_spec_type_from_file_location!

  config.mock_with :rspec
  config.color = true

  # Capybara javascript drivers require transactional fixtures set to false,
  # and we use DatabaseCleaner to cleanup after each test instead. Without
  # transactional fixtures set to false the records created to setup a test will
  # be unavailable to the browser, which runs under a separate server instance.
  config.use_transactional_fixtures = false

  # Ensure Suite is set to use transactions for speed.
  config.before :suite do
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.clean_with :truncation
  end

  # Before each spec check if it is a Javascript test and switch between using
  # database transactions or not where necessary.
  config.before :each do
    strategy = RSpec.current_example.metadata[:js] ? :truncation : :transaction
    DatabaseCleaner.strategy = strategy
    DatabaseCleaner.start
  end

  # After each spec clean the database.
  config.after :each do
    wait_for_ajax if RSpec.current_example.metadata[:js]

    DatabaseCleaner.clean
    Sidekiq::Worker.clear_all
  end

  config.fail_fast = ENV['FAIL_FAST'] || false
  config.order = "random"
end
