#!/usr/bin/env ruby
# frozen_string_literal: true

require 'bundler/setup'
require 'csv'

# Try to load Rails environment
begin
  require './config/environment'
  puts "Rails environment loaded successfully!"
rescue LoadError => e
  puts "Could not load Rails environment: #{e.message}"
  puts "Trying to load just ActiveRecord..."
  
  begin
    require 'active_record'
    require './config/database'
    puts "ActiveRecord loaded successfully!"
  rescue => e2
    puts "Could not load ActiveRecord: #{e2.message}"
    exit(1)
  end
end

# Define the path to cities.csv
cities_path = File.expand_path('../spec/fixtures/zipcodes/br/cities.csv', __dir__)

# Check if cities.csv exists
unless File.exist?(cities_path)
  puts "Error: Could not find cities.csv at #{cities_path}"
  exit(1)
end

# Build a map of state acronyms to state IDs
state_map = {}
if defined?(Addresses::State)
  state_map = Addresses::State.where(country_id: 26).pluck(:acronym, :id).to_h
  puts "Found #{state_map.size} states in the database"
else
  puts "Addresses::State model is not available"
  exit(1)
end

# Process cities
created = 0
already_exist = 0

puts "Processing cities from #{cities_path}..."

CSV.foreach(cities_path, headers: true) do |row|
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
    if city.save
      created += 1
      print '.' if (created % 100).zero? # Show progress
    else
      puts "\nError saving city #{city_name}, #{state_acronym}: #{city.errors.full_messages.join(', ')}"
    end
  else
    already_exist += 1
  end
end

puts "\nCities population complete!"
puts "- Created: #{created}"
puts "- Already existed: #{already_exist}"
puts "Total cities in database: #{Addresses::City.count}"
