# encoding: utf-8
# frozen_string_literal: true

require 'csv'
require 'fileutils'

namespace :extract do
  desc 'Extract unique cities from ceps.csv.zst to cities.csv'
  task :cities do
    begin
      # Define the paths relative to the gem root
      ceps_path = File.join(Addresses::Engine.root, 'spec/fixtures/zipcodes/br/ceps.csv.zst')
      
      unless File.exist?(ceps_path)
        puts "Error: Could not find ceps.csv.zst at #{ceps_path}"
        next
      end
      
      # Define the output path for cities.csv
      cities_path = File.join(Addresses::Engine.root, 'spec/fixtures/zipcodes/br/cities.csv')
      
      puts "Decompressing ceps.csv.zst..."
      decompressed_path = ceps_path.chomp('.zst')
      system("zstd -d --rm -f #{ceps_path.shellescape}") || raise("Failed to decompress #{ceps_path}")
      
      puts "Extracting unique cities from #{decompressed_path}..."
      
      # Read all cities and states from ceps.csv
      cities = {}
      CSV.foreach(decompressed_path, headers: true, col_sep: ',') do |row|
        state_acronym = row['estado']
        city_name = row['cidade']
        
        # Skip if either field is missing
        next if state_acronym.nil? || city_name.nil? || state_acronym.empty? || city_name.empty?
        
        # Use state and city as composite key to ensure uniqueness
        cities["#{state_acronym}-#{city_name}"] = {
          state_acronym: state_acronym.strip,
          city_name: city_name.strip
        }
      end
    
      # Ensure directory exists
      FileUtils.mkdir_p(File.dirname(cities_path))
      
      # Write unique cities to CSV
      CSV.open(cities_path, 'wb') do |csv|
        csv << ['state_acronym', 'city_name']
        cities.values.each do |city|
          csv << [city[:state_acronym], city[:city_name]]
        end
      end
      
      # Compress the cities.csv file
      system("zstd -9 --rm -f #{cities_path.shellescape}") || raise("Failed to compress #{cities_path}")
      
      puts "Successfully extracted #{cities.size} unique cities to #{cities_path}.zst"
    rescue StandardError => e
      puts "Error extracting cities: #{e.message}"
      puts e.backtrace.join("\n") if ENV['DEBUG']
      raise e
    ensure
      # Clean up the decompressed file
      FileUtils.rm_f(decompressed_path) if defined?(decompressed_path) && File.exist?(decompressed_path)
    end
  end
end
