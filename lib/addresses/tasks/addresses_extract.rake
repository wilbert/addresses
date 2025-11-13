# encoding: utf-8
# frozen_string_literal: true

module Addresses
  class AddressDataExtractor
    class << self
      def run
        require 'csv'
        require 'fileutils'
        
        # Get the root path of the gem
        root_path = if defined?(Addresses::Engine)
                      Addresses::Engine.root
                    else
                      Pathname.new(File.expand_path('../../../..', __dir__))
                    end
        
        # Define paths
        ceps_path = File.join(root_path, 'spec/fixtures/zipcodes/br/ceps.csv')
        cities_path = File.join(root_path, 'spec/fixtures/zipcodes/br/cities.csv')
        neighborhoods_path = File.join(root_path, 'spec/fixtures/zipcodes/br/neighborhoods.csv')
        
        puts "Extracting address data from #{ceps_path}..."

        begin
          # Ensure directory exists
          FileUtils.mkdir_p(File.dirname(cities_path))
          
          # Initialize data structures
          cities = {}
          neighborhoods = Set.new
          
          # Process the ceps.csv file in a single pass
          CSV.foreach(ceps_path, headers: true, col_sep: ',') do |row|
            state_acronym = row['estado']&.strip
            city_name = row['cidade']&.strip
            neighborhood_name = row['bairro']&.strip
            
            # Skip if required fields are missing
            next if state_acronym.to_s.empty? || city_name.to_s.empty?
            
            # Track unique cities
            city_key = "#{state_acronym}:#{city_name.downcase}"
            cities[city_key] = {
              state_acronym: state_acronym,
              city_name: city_name
            }
            
            # Track unique neighborhoods if neighborhood exists
            if neighborhood_name && !neighborhood_name.empty?
              neighborhoods << [state_acronym, city_name, neighborhood_name]
            end
          end
          
          # Write cities to CSV
          CSV.open(cities_path, 'wb') do |csv|
            csv << ['state_acronym', 'city_name']
            cities.values.each do |city|
              csv << [city[:state_acronym], city[:city_name]]
            end
          end
          
          # Write neighborhoods to CSV
          CSV.open(neighborhoods_path, 'wb') do |csv|
            csv << ['state_acronym', 'city_name', 'neighborhood_name']
            neighborhoods.sort.each { |row| csv << row }
          end
          
          # Compress the output files
          compress_file(cities_path)
          compress_file(neighborhoods_path)
          
          puts "Successfully extracted:"
          puts "- #{cities.size} unique cities to #{cities_path}.zst"
          puts "- #{neighborhoods.size} unique neighborhoods to #{neighborhoods_path}.zst"
          
          true
        rescue StandardError => e
          puts "Error extracting address data: #{e.message}"
          puts e.backtrace.join("\n") if ENV['DEBUG']
          false
        end
      end
      
      private
      
      def compress_file(file_path)
        return unless File.exist?(file_path)
        
        # Compress the file using zstd
        system("zstd -9 -f #{file_path.shellescape}") || raise("Failed to compress #{file_path}")
        
        # Remove the original file
        FileUtils.rm_f(file_path)
      end
    end
  end
end

namespace :addresses do
  namespace :br do
    desc 'Extract unique cities and neighborhoods from ceps.csv'
    task extract: :environment do
      success = Addresses::AddressDataExtractor.run
      exit(1) unless success
    end
  end
end
