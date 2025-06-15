require 'bundler/setup'
require 'active_record'
require 'yaml'

# Load the database configuration
puts "Loading database configuration..."
db_config = YAML.load(File.read('spec/dummy/config/database.yml'))['test']
puts "Connecting to database: #{db_config['database']}"
ActiveRecord::Base.establish_connection(db_config)

# Run the migration
puts "Running migrations..."
ActiveRecord::Migration.verbose = true
migration_context = ActiveRecord::MigrationContext.new('db/migrate')
puts "Pending migrations: #{migration_context.migrations.map(&:version)}"
migration_context.migrate

puts "Migrations completed successfully!"
