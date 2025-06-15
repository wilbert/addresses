# encoding: utf-8
# frozen_string_literal: true

module Addresses
  class CityExtractor
    def self.run
      require 'csv'
      require 'fileutils'
      
      # Determine the root path (works with or without Rails)
      root_path = if defined?(Rails) && defined?(Rails.root)
                    Rails.root
                  elsif defined?(Addresses::Engine)
                    Addresses::Engine.root
                  else
                    Pathname.new(File.expand_path('../../../..', __dir__))
                  end
      
      ceps_path = File.join(root_path, 'spec/fixtures/zipcodes/br/ceps.csv')
      cities_path = File.join(root_path, 'spec/fixtures/zipcodes/br/cities.csv')
      
      puts "Extracting unique cities from #{ceps_path}..."

      begin
        # Read all cities and states from ceps.csv
        cities = {}
        CSV.foreach(ceps_path, headers: true, col_sep: ',') do |row|
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

        puts "Successfully extracted #{cities.size} unique cities to #{cities_path}"
        true
      rescue StandardError => e
        puts "Error extracting cities: #{e.message}"
        puts e.backtrace.join("\n") if ENV['DEBUG']
        false
      end
    end
  end
end

namespace :addresses do
  namespace :br do
    namespace :cities do
      desc 'Extract unique cities from ceps.csv to cities.csv'
      task extract: :environment do
        begin
          require 'csv'
          require 'fileutils'
          
          # Get the root path of the gem
          gem_root = File.expand_path('../../..', __dir__)
          
          # Define the paths relative to the gem root
          ceps_path = File.join(gem_root, 'spec/fixtures/zipcodes/br/ceps.csv')
          cities_path = File.join(gem_root, 'spec/fixtures/zipcodes/br/cities.csv')
          
          puts "Extracting unique cities from #{ceps_path}..."
          
          # Read all cities and states from ceps.csv
          cities = {}
          CSV.foreach(ceps_path, headers: true, col_sep: ',') do |row|
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
          
          puts "Successfully extracted #{cities.size} unique cities to #{cities_path}"
        rescue StandardError => e
          puts "Error extracting cities: #{e.message}"
          puts e.backtrace.join("\n") if ENV['DEBUG']
          exit(1)
        end
      end
    end
  end
end
