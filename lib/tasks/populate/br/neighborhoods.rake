# encoding: utf-8
# frozen_string_literal: true
# This task populates neighborhoods from neighborhoods.csv
# Usage: rake addresses:br:neighborhoods

require 'csv'

namespace :addresses do
  namespace :br do
    namespace :neighborhoods do
      desc 'Extract unique neighborhoods from ceps.csv to neighborhoods.csv'
      task extract: :environment do
        require 'set'
        ceps_path = "#{Addresses::Engine.root}/spec/fixtures/zipcodes/br/ceps.csv.zst"
        neighborhoods_path = "#{Addresses::Engine.root}/spec/fixtures/zipcodes/br/neighborhoods.csv"
        
        # Decompress the file
        puts "Decompressing ceps.csv.zst..."
        decompressed_path = ceps_path.chomp('.zst')
        system("zstd -d --rm -f #{ceps_path.shellescape}") || raise("Failed to decompress #{ceps_path}")
        
        neighborhoods = Set.new
        CSV.foreach(decompressed_path, headers: false, col_sep: ',') do |row|
          # ceps.csv: zipcode, state_acronym, city_name, neighborhood_name, street_name
          _zipcode, state_acronym, city_name, neighborhood_name, _street = row.map(&:to_s)
          next if neighborhood_name.blank?
          neighborhoods << [state_acronym.strip, city_name.strip, neighborhood_name.strip]
        end

        # Write to neighborhoods.csv
        CSV.open(neighborhoods_path, 'w') do |csv|
          csv << ['state_acronym', 'city_name', 'neighborhood_name']
          neighborhoods.each { |row| csv << row }
        end
        
        # Compress the neighborhoods.csv file
        system("zstd -9 --rm -f #{neighborhoods_path.shellescape}") || raise("Failed to compress #{neighborhoods_path}")

        puts "Extracted #{neighborhoods.size} unique neighborhoods to #{neighborhoods_path}.zst"
      end
    end

    desc 'Populate all Brazilian neighborhoods'
    task populate: :environment do
      require 'set'
      neighborhoods_path = "#{Addresses::Engine.root}/spec/fixtures/zipcodes/br/neighborhoods.csv.zst"
      
      # First extract neighborhoods if the file doesn't exist
      unless File.exist?(neighborhoods_path)
        Rake::Task['addresses:br:neighborhoods:extract'].invoke
      end
      
      # Decompress the neighborhoods file
      puts "Decompressing neighborhoods.csv.zst..."
      decompressed_path = neighborhoods_path.chomp('.zst')
      system("zstd -d --rm -f #{neighborhoods_path.shellescape}") || raise("Failed to decompress #{neighborhoods_path}")
      
      begin
        # Rest of the population logic here

      puts 'Populating neighborhoods...'

      # Add neighborhood population logic here
      # This should be implemented based on your specific requirements

      ensure
        # Clean up the decompressed file
        FileUtils.rm_f(decompressed_path) if defined?(decompressed_path) && File.exist?(decompressed_path)
      end
      
      puts 'Neighborhoods populated successfully!'
    end
  end
end
