require 'bundler/setup'
require 'rdoc/task'

# Load all rake tasks from lib/tasks
Dir.glob('lib/tasks/**/*.rake').each { |r| load r }

# Load Rails environment if available
begin
  # Load Rails environment
  require File.expand_path('test/dummy/config/environment', __dir__)
  
  # Load Rails tasks
  load 'rails/tasks/engine.rake'
  
  # Load the application's Rakefile
  load 'rails/tasks/statistics.rake' rescue nil
  
  # Load all rake tasks from the engine
  Dir[File.join(File.dirname(__FILE__), 'lib/tasks/**/*.rake')].each { |f| load f }
  
  # Load the dummy app's Rakefile if it exists
  dummy_rakefile = File.expand_path('test/dummy/Rakefile', __dir__)
  load dummy_rakefile if File.exist?(dummy_rakefile)
  
  # Load Rails tasks for the dummy app
  Rails.application.load_tasks
rescue LoadError => e
  puts "Running in non-Rails mode: #{e.message}" if ENV['DEBUG']
rescue => e
  puts "Error loading Rails: #{e.message}\n#{e.backtrace.join("\n")}" if ENV['DEBUG']
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
