$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "addresses/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "addresses"
  s.version     = Addresses::VERSION
  s.authors     = ["Wilbert Ribeiro"]
  s.email       = ["wkelyson@gmail.com"]
  s.homepage    = "http://www.github.com/wilbert/addresses"
  s.summary     = "This engine allows create default addresses models for any usage."
  s.description = "Create Countr, State, City, Neighborhood and a polymorphic model called Address that can be related as addessable."

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.0.4"

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'capybara'
  s.add_development_dependency 'factory_girl_rails'
end
