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

        created = 0
        updated = 0

        puts "Populating cities from #{cities_path}..."

        # Process each row in the cities CSV
        CSV.foreach(csv_path, headers: true) do |row|
          state_acronym = row['state_acronym'].to_s.strip
          city_name = row['city_name'].to_s.strip
          state_id = state_map[state_acronym]

          next if state_id.nil? || city_name.empty?

          # Find or create the city
          city = Addresses::City.find_or_initialize_by(
            name: city_name,
            state_id: state_id
          )

          if city.new_record?
            city.save!
            created += 1
            print '.' if (created % 100).zero? # Show progress
          else
            updated += 1
          end
        end

        puts "\nCities population complete!"
        puts "- Created: #{created}"
        puts "- Updated: #{updated}"
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