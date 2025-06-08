begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

require 'rdoc/task'

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
