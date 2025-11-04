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
  # Disable rspec-rails ActiveRecord integration to avoid legacy fixture hooks
  config.use_active_record = false
  # Disable transactional fixtures since ActiveRecord integration is off
  config.use_transactional_fixtures = false

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  # Filter lines from Rails gems in backtraces.
  config.filter_rails_from_backtrace!
  # arbitrary gems may also be filtered via:
  # config.filter_gems_from_backtrace("gem name")

  # Restore original RSpec configurations
  config.mock_with :rspec
  config.infer_base_class_for_anonymous_controllers = false
  config.include FactoryBot::Syntax::Methods
  config.order = "random"
  config.include(Shoulda::Matchers::ActiveModel, type: :model)
  config.include(Shoulda::Matchers::ActiveRecord, type: :model)

  # Enable view rendering to avoid RSpec's EmptyTemplateResolver decorator
  # which is incompatible with Rails 7.1's resolver type checks
  config.render_views = true
end

# Load dummy app schema directly for engine tests
ActiveRecord::Schema.verbose = false
load File.expand_path("./dummy/db/schema.rb", __dir__)
