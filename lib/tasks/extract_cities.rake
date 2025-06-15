# encoding: utf-8
# frozen_string_literal: true

require 'csv'
require 'fileutils'

desc 'Extract unique cities from ceps.csv to cities.csv'
task 'extract:cities' do
  begin
    # Define the paths relative to the current directory (project root)
    ceps_path = File.expand_path('spec/fixtures/zipcodes/br/ceps.csv', __dir__)
    ceps_path = File.expand_path('../../spec/fixtures/zipcodes/br/ceps.csv', __dir__) unless File.exist?(ceps_path)
    
    # Define the output path for cities.csv
    cities_dir = File.dirname(ceps_path)
    cities_path = File.join(cities_dir, 'cities.csv')
    
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
