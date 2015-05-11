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
require 'ffaker'
require 'pry'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), 'support/**/*.rb')].each { |f| require f }

# Requires factories and other useful helpers defined in spree_core.
require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/factories'
require 'spree/testing_support/url_helpers'
require 'spree/testing_support/order_walkthrough'


RSpec.configure do |config|
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

  config.order = "random"
end
