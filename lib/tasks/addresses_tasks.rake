# encoding: utf-8
# frozen_string_literal: true

# Load all Rake tasks from the populate directory and its subdirectories
tasks_dir = File.expand_path('populate', __dir__)
Dir.glob(File.join(tasks_dir, '**/*.rake')).each { |file| load file }

namespace :addresses do
  namespace :br do
    desc 'Populate all Brazilian address data (countries, states, cities, neighborhoods, and addresses)'
    task all: [:environment] do
      # First ensure countries are loaded
      Rake::Task['addresses:br:countries'].invoke
      
      # Then load Brazilian regions and states
      Rake::Task['addresses:br:regions'].invoke
      Rake::Task['addresses:br:states'].invoke
      
      # Finally load the rest of the data
      Rake::Task['addresses:br:cities'].invoke
      Rake::Task['addresses:br:neighborhoods'].invoke
      Rake::Task['addresses:br:zipcodes'].invoke
    end
  end

  namespace :br do
    namespace :cities do
      desc 'Extract unique cities from ceps.csv to cities.csv'
      task extract: :environment do
        require 'csv'
        
        ceps_path = "#{Addresses::Engine.root}/spec/fixtures/zipcodes/br/ceps.csv"
        cities_path = "#{Addresses::Engine.root}/spec/fixtures/zipcodes/br/cities.csv"
        
        puts "Extracting unique cities from #{ceps_path}..."

        # Read all cities and states from ceps.csv
        cities = {}
        CSV.foreach(ceps_path, headers: true, col_sep: ',') do |row|
          state_acronym = row['estado']
          city_name = row['cidade']
          
          # Use state and city as composite key to ensure uniqueness
          cities["#{state_acronym}-#{city_name}"] = {
            state_acronym: state_acronym,
            city_name: city_name
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

        puts "Extracted #{cities.size} unique cities to #{cities_path}"
      end
    end
  end

  desc 'Clean all address models'
  task clean: :environment do
    puts 'Cleaning addresses models'
    
    # Define all address models in the order of dependencies (children first)
    address_models = [
      Addresses::Address,
      Addresses::Zipcode,
      Addresses::Neighborhood,
      Addresses::City,
      Addresses::Region,
      Addresses::State,
      Addresses::Country
    ]
    
    address_models.each do |model|
      if model.table_exists?
        puts "Deleting all records from #{model.table_name}..."
        model.delete_all
      else
        puts "Skipping #{model.table_name} - table does not exist"
      end
    end
  end
end
