# encoding: utf-8
# This task populates neighborhoods from neighborhoods.csv
# Usage: rake br:populate:neighborhoods

require 'csv'

namespace :populate do
  namespace :br do
    desc 'Extract unique neighborhoods from ceps.csv to neighborhoods.csv'
    task extract_neighborhoods: :environment do
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

  namespace :br do
    namespace :generate do
      desc 'Extract unique neighborhoods from ceps.csv to neighborhoods.csv'
      task neighborhoods: :environment do
        require 'set'
        ceps_path = "#{Addresses::Engine.root}/spec/fixtures/zipcodes/br/ceps.csv"
        neighborhoods_path = "#{Addresses::Engine.root}/spec/fixtures/zipcodes/br/neighborhoods.csv"

        neighborhoods = Set.new
        CSV.foreach(ceps_path, headers: false, col_sep: ',') do |row|
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
  end
end
