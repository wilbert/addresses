# encoding: utf-8
require 'csv'
require 'io/console'

namespace :populate do
  namespace :br do
    desc 'Populate Brazilian Zipcodes'
    task zipcodes: [:environment] do
      puts 'Populating Zipcodes'
      csv_path = "#{Addresses::Engine.root}/spec/fixtures/zipcodes/br/ceps.csv"
      batch = []
      batch_size = 5000
      upsert_columns = [:number, :city_id, :neighborhood_id, :street]
      total = `wc -l < "#{csv_path}"`.to_i
      processed = 0
      last_percent = -1
      CSV.foreach(csv_path, headers: false, col_sep: ',') do |row|
        # Assign columns based on the actual ceps.csv pattern
        zipcode_number, state_acronym, city_name, neighborhood_name, street_name = row.map(&:to_s)

        # Find or create state
        state = Addresses::State.find_by(acronym: state_acronym)
        unless state
          state = Addresses::State.new(acronym: state_acronym, name: state_acronym)
          if state.save
            puts "[INFO] Created state: #{state_acronym}"
          else
            puts "[ERROR] Could not create state: #{state_acronym} - #{state.errors.full_messages.join(', ')}"
            next
          end
        end

        # Only proceed if state is persisted
        unless state.persisted?
          puts "[ERROR] State not persisted: #{state_acronym}"
          next
        end

        # Find or create city
        city = state.cities.find_by(name: city_name)
        unless city
          city = state.cities.create(name: city_name)
          if city.persisted?
            puts "[INFO] Created city: #{city_name} in state: #{state_acronym}"
          else
            puts "[ERROR] Could not create city: #{city_name} in state: #{state_acronym} - #{city.errors.full_messages.join(', ')}"
            next
          end
        end

        # Find or create neighborhood if present
        neighborhood = nil
        unless neighborhood_name.blank?
          if city.neighborhoods.column_names.include?("name")
            neighborhood = city.neighborhoods.where('LOWER(name) = ?', neighborhood_name.downcase).first
          else
            neighborhood = city.neighborhoods.to_a.find { |n| n.name.to_s.downcase == neighborhood_name.downcase }
          end
          unless neighborhood
            neighborhood = city.neighborhoods.create(name: neighborhood_name)
            puts "[INFO] Created neighborhood: #{neighborhood_name} in city: #{city_name}"
          end
        end

        # Avoid duplicate zipcodes (number, city, neighborhood, street)
        existing_zipcode = Addresses::Zipcode.find_by(
          number: zipcode_number,
          city_id: city.id,
          neighborhood_id: neighborhood&.id,
          street: street_name
        )
        if existing_zipcode
          puts "[INFO] Zipcode already exists: #{zipcode_number} in state: #{state_acronym}, city: #{city_name}, neighborhood: #{neighborhood_name}, street: #{street_name}"
          next
        end

        zipcode_attrs = {
          city_id: city.id,
          neighborhood_id: neighborhood.try(:id),
          street: street_name,
          number: zipcode_number
        }
        batch << zipcode_attrs

        if batch.size >= batch_size
          Addresses::Zipcode.upsert_all(batch, unique_by: {columns: upsert_columns})
          puts "[INFO] Upserted batch of #{batch.size} zipcodes."
          batch.clear
        end

        processed += 1
        percent = (processed * 100 / total rescue 0)
        if percent != last_percent && percent % 2 == 0
          print "\rProgress: #{percent}% (#{processed}/#{total})"
          last_percent = percent
        end
      end
      puts "\rProgress: 100% (#{processed}/#{total})"
      # Insert any remaining zipcodes
      unless batch.empty?
        Addresses::Zipcode.upsert_all(batch, unique_by: {columns: upsert_columns})
        puts "[INFO] Upserted final batch of #{batch.size} zipcodes."
      end
    end
  end
end
