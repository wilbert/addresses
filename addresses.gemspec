$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "addresses"
  s.authors     = ["Wilbert Ribeiro", "Joice Taciana", "Raí Gondim"]
  s.email       = ["wkelyson@gmail.com", "joicetaciana@gmail.com", "raicg2@gmail.com"]
  s.version     = '3.0.0'
  s.homepage    = "http://www.github.com/wilbert/addresses"
  s.summary     = "This engine allows create default addresses models for any usage."
  s.description = "Create Country, State, City, Neighborhood and a polymorphic model called Address that can be related as addessable."
  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]
  s.licenses    = ['MIT']
  s.required_ruby_version = '~> 3.0'

  s.add_dependency "rails", '~> 7.1'

  s.add_development_dependency 'rspec-rails',           '~> 5.1'
  s.add_development_dependency 'factory_bot_rails',     '~> 5.1.1'
end
