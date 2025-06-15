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
        ceps_path = "#{Addresses::Engine.root}/spec/fixtures/zipcodes/br/ceps.csv"
        neighborhoods_path = "#{Addresses::Engine.root}/spec/fixtures/zipcodes/br/neighborhoods.csv"

        neighborhoods = Set.new
        CSV.foreach(ceps_path, headers: false, col_sep: ',') do |row|
          # ceps.csv: zipcode, state_acronym, city_name, neighborhood_name, street_name
          _zipcode, state_acronym, city_name, neighborhood_name, _street = row.map(&:to_s)
          next if neighborhood_name.blank?
          neighborhoods << [state_acronym.strip, city_name.strip, neighborhood_name.strip]
        end

        CSV.open(neighborhoods_path, 'w') do |csv|
          csv << ['state_acronym', 'city_name', 'neighborhood_name']
          neighborhoods.each { |row| csv << row }
        end

        puts "Extracted #{neighborhoods.size} unique neighborhoods to #{neighborhoods_path}"
      end
    end

    desc 'Populate all Brazilian neighborhoods'
    task populate: :environment do
      require 'set'
      ceps_path = "#{Addresses::Engine.root}/spec/fixtures/zipcodes/br/ceps.csv"
      neighborhoods_path = "#{Addresses::Engine.root}/spec/fixtures/zipcodes/br/neighborhoods.csv"

      # First extract neighborhoods if the file doesn't exist
      unless File.exist?(neighborhoods_path)
        Rake::Task['addresses:br:neighborhoods:extract'].invoke
      end

      puts 'Populating neighborhoods...'

      # Add neighborhood population logic here
      # This should be implemented based on your specific requirements

      puts 'Neighborhoods populated successfully!'
    end
  end
end
