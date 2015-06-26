require "capybara"
require "capybara/rspec"
require "capybara/rails"
require "capybara/poltergeist"

require "spree/testing_support/capybara_ext"

Capybara.javascript_driver = :poltergeist
# Capybara.default_wait_time = 10

RSpec.configure do |config|
  config.include Capybara::DSL

  config.after :each do
    wait_for_ajax if RSpec.current_example.metadata[:js]
  end
end
