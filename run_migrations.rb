# Load Rails environment
require_relative 'spec/dummy/config/environment'

# Run migrations
puts "Running migrations..."
ActiveRecord::Migration.verbose = true
migration_context = ActiveRecord::MigrationContext.new('db/migrate')
puts "Pending migrations: #{migration_context.migrations.map(&:version)}"
migration_context.migrate

puts "Migrations completed successfully!"
