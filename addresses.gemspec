$:.push File.expand_path("../lib", __FILE__)

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "addresses"
  s.authors     = ["Wilbert Ribeiro", "Joice Taciana", "Raí Gondim"]
  s.email       = ["wkelyson@gmail.com", "joicetaciana@gmail.com", "raicg2@gmail.com"]
  s.version     = '4.0.0'
  s.homepage    = "http://www.github.com/wilbert/addresses"
  s.summary     = "This engine allows create default addresses models for any usage."
  s.description = "Create Country, State, City, Neighborhood and a polymorphic model called Address that can be related as addessable."
  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]
  s.licenses    = ['MIT']
  s.required_ruby_version = '~> 3.0'

  s.add_dependency "rails", '~> 8.0'

  s.add_development_dependency 'rspec-rails',           '~> 6.0'
  s.add_development_dependency 'factory_bot_rails',     '~> 6.4'
  s.add_development_dependency 'simplecov',             '~> 0.22'
  s.add_development_dependency 'shoulda-matchers',      '~> 5.3'
  s.add_development_dependency 'webmock',               '~> 3.19'
  s.add_development_dependency 'vcr',                   '~> 6.2'
  s.add_development_dependency 'rails-controller-testing', '~> 1.0.5'
end
