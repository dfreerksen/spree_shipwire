require 'sidekiq/testing'
require 'rspec-sidekiq'

Sidekiq::Testing.fake!

RSpec::Sidekiq.configure do |config|
  config.warn_when_jobs_not_processed_by_sidekiq = false
end

RSpec.configure do |config|
  config.after :each do
    Sidekiq::Worker.clear_all
  end
end
