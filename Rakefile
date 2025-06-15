require 'bundler/setup'
require 'rdoc/task'

# Load all rake tasks from lib/tasks
Dir.glob('lib/tasks/**/*.rake').each { |r| load r }

# Try to load Rails environment if available
begin
  require 'rails'
  require 'rails/generators'
  require 'rails/generators/rails/app/app_generator'
  
  # Load the Rails application and engine
  require File.expand_path('test/dummy/config/application', __dir__)
  ::Rails.application.initialize!
  ::Rails.application.load_tasks
rescue LoadError, StandardError => e
  puts "Running in non-Rails mode: #{e.message}" if ENV['DEBUG']
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'Addresses'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Bundler::GemHelper.install_tasks
APP_RAKEFILE = File.expand_path("../spec/dummy/Rakefile", __FILE__)
# load 'rails/tasks/engine.rake' # Removed: not needed for Rails 5+ or modern gem structure

# require 'rspec/core'
# require 'rspec/core/rake_task'
#
# desc "Run all specs in spec directory (excluding plugin specs)"
# RSpec::Core::RakeTask.new(:spec => 'app:db:test:prepare')
#
# task :default => :spec
