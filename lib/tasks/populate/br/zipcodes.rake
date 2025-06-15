# encoding: utf-8
# frozen_string_literal: true

require 'csv'
require 'io/console'

namespace :addresses do
  namespace :br do
    desc 'Populate all Brazilian zipcodes from official CSV'
    task zipcodes: [:environment] do
      puts 'Populating Zipcodes'

      csv_path = File.join(Addresses::Engine.root, 'spec/fixtures/zipcodes/br/ceps.csv.zst')
      batch = []
      batch_size = 5000
      upsert_columns = [:number, :city_id, :neighborhood_id, :street]

      country = Addresses::Country.find_or_create_by(acronym: 'BR') do |c|
        c.name = 'Brasil'
      end

      region_map = {
        'AC' => { name: 'Norte', acronym: 'N' },
        'AP' => { name: 'Norte', acronym: 'N' },
        'AM' => { name: 'Norte', acronym: 'N' },
        'PA' => { name: 'Norte', acronym: 'N' },
        'RO' => { name: 'Norte', acronym: 'N' },
        'RR' => { name: 'Norte', acronym: 'N' },
        'TO' => { name: 'Norte', acronym: 'N' },
        'AL' => { name: 'Nordeste', acronym: 'NE' },
        'BA' => { name: 'Nordeste', acronym: 'NE' },
        'CE' => { name: 'Nordeste', acronym: 'NE' },
        'MA' => { name: 'Nordeste', acronym: 'NE' },
        'PB' => { name: 'Nordeste', acronym: 'NE' },
        'PE' => { name: 'Nordeste', acronym: 'NE' },
        'PI' => { name: 'Nordeste', acronym: 'NE' },
        'RN' => { name: 'Nordeste', acronym: 'NE' },
        'SE' => { name: 'Nordeste', acronym: 'NE' },
        'DF' => { name: 'Centro-Oeste', acronym: 'CO' },
        'GO' => { name: 'Centro-Oeste', acronym: 'CO' },
        'MT' => { name: 'Centro-Oeste', acronym: 'CO' },
        'MS' => { name: 'Centro-Oeste', acronym: 'CO' },
        'ES' => { name: 'Sudeste', acronym: 'SE' },
        'MG' => { name: 'Sudeste', acronym: 'SE' },
        'RJ' => { name: 'Sudeste', acronym: 'SE' },
        'SP' => { name: 'Sudeste', acronym: 'SE' },
        'PR' => { name: 'Sul', acronym: 'S' },
        'RS' => { name: 'Sul', acronym: 'S' },
        'SC' => { name: 'Sul', acronym: 'S' }
      }

      total = `wc -l < "#{csv_path}"`.to_i
      processed = 0
      last_percent = -1
      CSV.foreach(csv_path, headers: false, col_sep: ',') do |row|
        zipcode_number, state_acronym, city_name, neighborhood_name, street_name = row.map(&:to_s)
        zipcode_number = zipcode_number.strip
        state_acronym = state_acronym.strip
        city_name = city_name.strip
        neighborhood_name = neighborhood_name.strip
        street_name = street_name.strip

        region_attrs = region_map[state_acronym]
        region = nil
        if region_attrs
          region = country.regions.where('LOWER(name) = ?', region_attrs[:name].downcase).first
          region ||= country.regions.create(name: region_attrs[:name], acronym: region_attrs[:acronym])
        end

        state = Addresses::State.where('LOWER(acronym) = ?', state_acronym.downcase).first
        state ||= country.states.new(acronym: state_acronym, name: state_acronym, region: region)
        unless state.persisted?
          state.save
          puts "[INFO] Created state: #{state_acronym}" if state.persisted?
        end
        next unless state.persisted?

        city = state.cities.where('LOWER(name) = ?', city_name.to_s.strip.downcase).first
        unless city
          city = state.cities.create(name: city_name)
          puts "[INFO] Created city: #{city_name} in state: #{state_acronym}" if city.persisted?
        end

        # Find or create neighborhood if present
        neighborhood = nil
        unless neighborhood_name.blank?
          neighborhood = city.neighborhoods.where('LOWER(name) = ?', neighborhood_name.to_s.strip.downcase).first
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
          Addresses::Zipcode.upsert_all(batch, unique_by: { columns: upsert_columns })
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
        Addresses::Zipcode.upsert_all(batch, unique_by: { columns: upsert_columns })
        puts "[INFO] Upserted final batch of #{batch.size} zipcodes."
      end

      # Clean up the decompressed CSV file if it was created by us
      if defined?(decompressed_path) && decompressed_path.end_with?('.csv')
        Addresses::CompressionUtils.cleanup_decompressed(decompressed_path)
      end
    rescue => e
      puts "Error processing zipcodes: #{e.message}"
      raise
    end
  end
end
