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

        created = 0
        updated = 0

        puts "Populating neighborhoods from #{csv_path}..."

        # Process each row in the neighborhoods CSV
        CSV.foreach(csv_path, headers: true) do |row|
          state_acronym = row['state_acronym'].to_s.strip
          city_name = row['city_name'].to_s.strip
          neighborhood_name = row['neighborhood_name'].to_s.strip
          
          next if state_acronym.blank? || city_name.blank? || neighborhood_name.blank?
          
          # Find the city using the state acronym and city name
          city_key = "#{state_acronym}:#{city_name.downcase}"
          city_id = city_map[city_key]
          
          unless city_id
            puts "Warning: Could not find city #{city_name}, #{state_acronym}"
            next
          end
          
          # Find or initialize the neighborhood
          neighborhood = Addresses::Neighborhood.find_or_initialize_by(
            name: neighborhood_name,
            city_id: city_id
          )
          
          if neighborhood.new_record?
            neighborhood.save!
            created += 1
            print '.' if (created % 1000).zero? # Show progress every 1000 records
          else
            updated += 1
          end
        end

        puts "\nNeighborhoods population complete!"
        puts "- Created: #{created}"
        puts "- Updated: #{updated}"
        
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

namespace :addresses do
  namespace :br do
    desc 'Populate all Brazilian neighborhoods from neighborhoods.csv.zst'
    task neighborhoods: :environment do
      success = Addresses::NeighborhoodPopulator.run
      exit(1) unless success
    end
  end
end
