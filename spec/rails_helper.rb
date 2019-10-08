ENV['RAILS_ENV'] ||= 'test'

if ENV['RAILS_ENV'] == 'test'
  require 'simplecov'
  SimpleCov.start 'rails'
  puts "required simplecov"
end

require File.expand_path("../dummy/config/environment.rb",  __FILE__)

require 'rspec/rails'
require 'shoulda/matchers'
require 'webmock/rspec'
require 'factory_bot_rails'

VCR.configure do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
end

Rails.backtrace_cleaner.remove_silencers!
# Load support files

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f; }

RSpec.configure do |config|
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.include FactoryBot::Syntax::Methods
  config.order = "random"
  config.include(Shoulda::Matchers::ActiveModel, type: :model)
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)
end
