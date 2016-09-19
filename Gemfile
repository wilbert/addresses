source "https://rubygems.org"

# Declare your gem's dependencies in addresses.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use debugger
# gem 'debugger'
#
gem "active_model_serializers", github: "rails-api/active_model_serializers"

group :test, :development do
  gem 'responders',   '2.2.0'
  gem 'pry-rails',    '0.3.4'
  gem 'pry-nav',      '0.2.4'
  gem 'sqlite3',      '1.3.11'
end

group :test do
  gem 'rails-controller-testing',   '1.0.1'
  gem 'shoulda-matchers',           '3.1.1'
  gem 'simplecov',                  '0.12.0'
end
