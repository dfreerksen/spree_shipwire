# Coverage
require "simplecov"
SimpleCov.start :rails do
  add_group "Workers", "app/workers"
end

# Rails environment
ENV["RAILS_ENV"] = "test"

begin
  require File.expand_path("../dummy/config/environment.rb",  __FILE__)
rescue LoadError
  puts "Could not load dummy application. Run `bundle exec rake test_app` first"
  exit
end

require "rspec/rails"
require "ffaker"
require "pry"

Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each { |f| require f }

require "spree/testing_support/authorization_helpers"
require "spree/testing_support/controller_requests"
require "spree/testing_support/factories"
require "spree/testing_support/url_helpers"
require "spree/testing_support/order_walkthrough"

RSpec.configure do |config|
  config.include Spree::TestingSupport::ControllerRequests
  config.include FactoryGirl::Syntax::Methods
  config.include Spree::TestingSupport::UrlHelpers
  config.include Devise::TestHelpers, type: :controller

  config.deprecation_stream = "rspec.log"

  config.expose_current_running_example_as :example

  # config.profile_examples = 10

  config.infer_spec_type_from_file_location!

  config.mock_with :rspec

  config.use_transactional_fixtures = false

  config.order = "random"
end
