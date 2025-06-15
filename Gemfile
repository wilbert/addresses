source "https://rubygems.org"

# Override sqlite3 version for Rails 7.1.2 compatibility


gemspec

group :test, :development do
  gem 'pry-rails'
  gem 'pry-nav'
  gem 'rubocop'
  gem 'rubocop-performance'
  gem 'rubocop-rspec'
  gem 'rubocop-rails'
  gem 'csv'
end

group :test do
  gem 'rails-controller-testing',   '1.0.4'
  gem 'shoulda-matchers'
  gem 'simplecov'
  gem 'webmock'
  gem 'vcr'
end

gem "sqlite3", "~> 2.7"
