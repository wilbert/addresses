# encoding: utf-8
# frozen_string_literal: true
# This task populates neighborhoods from neighborhoods.csv
# Usage: rake addresses:br:neighborhoods

require 'csv'

module Addresses
  class NeighborhoodPopulator
    def self.run
      # Get the path to the neighborhoods.csv.zst file
      neighborhoods_path = File.join(Addresses::Engine.root, 'spec/fixtures/zipcodes/br/neighborhoods.csv.zst')

      begin
        # Check if neighborhoods.csv.zst exists, if not, run the extract task
        unless File.exist?(neighborhoods_path)
          puts 'Neighborhoods CSV not found. Please run `rake addresses:br:extract` first to generate the required files.'
          return false
        end

        # Decompress the file (keep the .zst file)
        puts "Decompressing neighborhoods data..."
        csv_path = neighborhoods_path.chomp('.zst')
        system("zstd -d -f #{neighborhoods_path.shellescape}") || raise("Failed to decompress #{neighborhoods_path}")

        # Verify the file was created
        unless File.exist?(csv_path)
          puts "Error: Could not find neighborhoods.csv at #{csv_path}"
          return false
        end

        # Build a map of city keys (state_acronym + city_name) to city IDs
        city_map = {}
        Addresses::City.includes(:state).find_each do |city|
          key = "#{city.state.acronym}:#{city.name.downcase}"
          city_map[key] = city.id
        end

        puts "Populating neighborhoods from #{csv_path}..."
        
        # Prepare data for bulk upsert
        neighborhoods_data = []
        
        CSV.foreach(csv_path, headers: true) do |row|
          state_acronym = row['state_acronym'].to_s.strip
          city_name = row['city_name'].to_s.strip
          neighborhood_name = row['neighborhood_name'].to_s.strip
          
          next if state_acronym.blank? || city_name.blank? || neighborhood_name.blank?
          
          # Find the city using the state acronym and city name
          city_key = "#{state_acronym}:#{city_name.downcase}"
          city_id = city_map[city_key]
          
          unless city_id
            puts "Warning: Could not find city #{city_name}, #{state_acronym}" if ENV['DEBUG']
            next
          end
          
          # Prepare the data hash
          data = {
            name: neighborhood_name,
            city_id: city_id,
            created_at: Time.current,
            updated_at: Time.current
          }
          
          # Only add unaccented_name if the column exists
          if Addresses::Neighborhood.column_names.include?('unaccented_name')
            data[:unaccented_name] = neighborhood_name.unicode_normalize(:nfd).gsub(/[^\x00-\x7F]/n, '').downcase
          end
          
          neighborhoods_data << data
          
          # Print progress
          print '.' if neighborhoods_data.size % 1000 == 0
        end
        
        # Remove duplicates (same unaccented_name and city_id)
        neighborhoods_data.uniq! { |n| [n[:unaccented_name], n[:city_id]] }
        
        # Process in smaller batches to avoid memory issues
        batch_size = 5000
        created_count = 0
        updated_count = 0
        total = neighborhoods_data.size
        
        puts "Processing #{total} neighborhood records in batches of #{batch_size}..."
        
        # Process each batch
        neighborhoods_data.each_slice(batch_size).with_index do |batch, index|
          # Clear query cache for each batch
          Addresses::Neighborhood.connection.clear_query_cache
          
          # Process each record in the batch
          batch.each do |neighborhood|
            # Try to find existing record, using unaccented_name if available
            existing = if Addresses::Neighborhood.column_names.include?('unaccented_name') && neighborhood[:unaccented_name]
              Addresses::Neighborhood.find_by(
                'unaccented_name = ? AND city_id = ?',
                neighborhood[:unaccented_name],
                neighborhood[:city_id]
              )
            else
              Addresses::Neighborhood.find_by(
                'LOWER(name) = ? AND city_id = ?',
                neighborhood[:name].downcase,
                neighborhood[:city_id]
              )
            end
            
            if existing
              # Update timestamp if record exists
              existing.touch
              updated_count += 1
            else
              # Create new record if it doesn't exist
              Addresses::Neighborhood.create!(
                name: neighborhood[:name],
                city_id: neighborhood[:city_id],
                created_at: Time.current,
                updated_at: Time.current
              )
              created_count += 1
            end
            
            # Show progress every 1000 records
            if (created_count + updated_count) % 1000 == 0
              puts "Processed #{created_count + updated_count}/#{total} records..."
            end
          end
          
          # Force garbage collection every batch
          GC.start if index % 10 == 0
        end
        
        { created_count: created_count, updated_count: updated_count }
        
        puts "\nNeighborhoods population complete!"
        puts "- Processed: #{neighborhoods_data.size} records"
        puts "- Created: #{result[:created_count]} new records"
        puts "- Updated: #{result[:updated_count]} existing records"
        
        true
      rescue => e
        puts "Error populating neighborhoods: #{e.message}"
        puts e.backtrace.join("\n") if ENV['DEBUG']
        false
      ensure
        # Clean up the decompressed CSV file if it was created by us
        if defined?(csv_path) && csv_path.end_with?('.csv') && File.exist?(csv_path)
          Addresses::CompressionUtils.cleanup_decompressed(csv_path)
        end
      end
    end
  end
end

# lib/tasks/populate/br/neighborhoods.rake
namespace :addresses do
  namespace :br do
    desc 'Populate all Brazilian neighborhoods from neighborhoods.csv.zst'
    task neighborhoods: :environment do
      # Ensure the environment is loaded
      require File.expand_path('spec/dummy/config/environment', Rails.root)
      success = Addresses::NeighborhoodPopulator.run
      exit(1) unless success
    end
  end
end