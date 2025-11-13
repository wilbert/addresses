# encoding: utf-8
# frozen_string_literal: true

require 'csv'
require 'fileutils'

module Addresses
  class CityPopulator
    def self.run
      # Get the path to the cities.csv.zst file
      cities_path = File.join(Addresses::Engine.root, 'spec/fixtures/zipcodes/br/cities.csv.zst')

      begin
        # Check if cities.csv.zst exists, if not, run the extract task
        unless File.exist?(cities_path)
          puts 'Cities CSV not found. Running extract task...'
          Rake::Task['extract:cities'].invoke

          # Compress the file after extraction
          csv_path = File.join(Addresses::Engine.root, 'spec/fixtures/zipcodes/br/cities.csv')
          if File.exist?(csv_path)
            system("zstd -9 --rm -f #{csv_path.shellescape}") || raise("Failed to compress #{csv_path}")
          end
        end

        # Decompress the file (keep the .zst file)
        puts "Decompressing cities data..."
        csv_path = cities_path.chomp('.zst')
        system("zstd -d -f #{cities_path.shellescape}") || raise("Failed to decompress #{cities_path}")

        # Verify the file was created
        unless File.exist?(csv_path)
          puts "Error: Could not find cities.csv at #{csv_path}"
          return false
        end

        # Build a map of state acronyms to state IDs
        state_map = Addresses::State.where(country_id: 26).pluck(:acronym, :id).to_h

        puts "Populating cities from #{csv_path}..."
        
        # Prepare data for bulk upsert
        cities_data = []
        CSV.foreach(csv_path, headers: true) do |row|
          state_acronym = row['state_acronym'].to_s.strip
          city_name = row['city_name'].to_s.strip
          state_id = state_map[state_acronym]

          next if state_id.nil? || city_name.empty?
          
          cities_data << {
            name: city_name,
            state_id: state_id,
            created_at: Time.current,
            updated_at: Time.current
          }
          
          # Print progress
          print '.' if cities_data.size % 1000 == 0
        end
        
        # Remove duplicates (same name and state_id)
        cities_data.uniq! { |c| [c[:name].downcase, c[:state_id]] }
        
        # Bulk upsert cities
        # First ensure we have the latest data in case of concurrent updates
        Addresses::City.connection.clear_query_cache
        
        # Group by unique name (case-insensitive) and state_id
        cities_data.uniq! { |c| [c[:name].downcase, c[:state_id]] }
        
        # Use a transaction for atomicity
        result = Addresses::City.transaction do
          # First, update existing records to mark them as touched
          existing = Addresses::City.where(
            'LOWER(name) IN (?) AND state_id IN (?)',
            cities_data.map { |c| c[:name].downcase }.uniq,
            cities_data.map { |c| c[:state_id] }.uniq
          )
          
          # Update timestamps for existing records
          existing.update_all(updated_at: Time.current)
          
          # Insert only new records
          new_records = cities_data.reject do |city|
            existing.any? { |e| 
              e.name.downcase == city[:name].downcase && e.state_id == city[:state_id] 
            }
          end
          
          # Insert new records in batches
          new_records.each_slice(1000) do |batch|
            Addresses::City.insert_all(batch) unless batch.empty?
          end
          
          { updated_count: existing.count, created_count: new_records.size }
        end
        
        puts "\nCities population complete!"
        puts "- Processed: #{cities_data.size} records"
        puts "- Created: #{result[:created_count]} new records"
        puts "- Updated: #{result[:updated_count]} existing records"
        puts "Total cities in database: #{Addresses::City.count}"

        true
      rescue StandardError => e
        puts "\nError populating cities: #{e.message}"
        puts e.backtrace.join("\n") if ENV['DEBUG']
        false
      ensure
        # Clean up the decompressed CSV file (keep the .zst file)
        FileUtils.rm_f(csv_path) if csv_path.end_with?('.csv') && File.exist?(csv_path)
      end
    end
  end
end

namespace :addresses do
  namespace :br do
    desc 'Populate all Brazilian cities from cities.csv'
    task :cities do
      # Load Rails environment if available
      begin
        require File.expand_path('config/environment', Rails.root) if defined?(Rails)
      rescue => e
        puts "Warning: Could not load Rails environment - #{e.message}"
      end
      
      success = Addresses::CityPopulator.run
      exit(1) unless success
    end
  end
end