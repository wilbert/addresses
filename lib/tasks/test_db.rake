namespace :test do
  desc 'Test database connection'
  task :db do
    begin
      # Try to load Rails environment
      require File.expand_path('config/environment', Rails.root) if defined?(Rails)
      
      # Try to access the database
      if defined?(ActiveRecord::Base)
        puts "Successfully connected to database!"
        puts "Database: #{ActiveRecord::Base.connection.current_database}"
        puts "Cities table exists: #{ActiveRecord::Base.connection.table_exists?('addresses_cities')}"
      else
        puts "ActiveRecord is not available"
      end
    rescue => e
      puts "Error: #{e.message}"
      puts e.backtrace.join("\n") if ENV['DEBUG']
      exit(1)
    end
  end
end
