lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "spree_shipwire/version"

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "spree_shipwire"
  s.version     = SpreeShipwire::VERSION
  s.authors     = ["David Freerksen"]
  s.homepage    = "https://github.com/dfreerksen/shipwire"
  s.summary     = "Shipwire. For Spree. Without Wombat."
  s.description = s.summary
  s.license     = "MIT"

  s.required_ruby_version = '>= 1.9.3'

  s.files = Dir[
    "{app,config,db,lib}/**/*",
    "MIT-LICENSE",
    "Rakefile",
    "README.md"
  ]

  s.test_files   = `git ls-files -- spec/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 2.4.6'
  s.add_dependency 'httparty', '~> 0.13.3'
  s.add_dependency 'sidekiq', '~> 3.3.3'

  s.add_development_dependency 'rspec-rails',  '~> 3.1'
  s.add_development_dependency 'factory_girl', '~> 4.5'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'rspec-sidekiq', '~> 2.0.0'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'capybara', '~> 2.4'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'sass-rails', '~> 4.0.2'
  s.add_development_dependency 'poltergeist', '1.5'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'selenium-webdriver'
  s.add_development_dependency 'pry', '~> 0.9'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'launchy'
end
