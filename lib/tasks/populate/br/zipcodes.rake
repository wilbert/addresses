# encoding: utf-8
# frozen_string_literal: true

require 'csv'
require 'io/console'

module Addresses
  class ZipcodePopulator
    def self.process_zipcode_batch(batch, unique_by)
      return if batch.empty?
      
      begin
        # Remove updated_at from the batch data to avoid multiple assignments
        batch.each { |item| item.delete(:updated_at) }
        
        result = Addresses::Zipcode.upsert_all(
          batch,
          unique_by: :index_addresses_zipcodes_on_number_and_city_and_neighborhood_and_street,
          update_only: []  # Let the database handle timestamps
        )
        
        puts "[INFO] Upserted batch of #{result.rows.size} zipcodes." if ENV['DEBUG']
        result
      rescue => e
        puts "[ERROR] Failed to upsert batch: #{e.message}"
        raise
      end
    end
    
    def self.run
      puts 'Populating Zipcodes'
      
      csv_path = File.join(Addresses::Engine.root, 'spec/fixtures/zipcodes/br/ceps.csv.zst')
      batch_size = 5000
      upsert_columns = [:number, :city_id, :neighborhood_id, :street]
      zipcode_data = []
      
      # Preload all states and cities for faster lookups
      puts "Preloading states and cities..."
      state_map = {}
      city_map = {}
      
      Addresses::State.includes(:cities).find_each do |state|
        state_map[state.acronym.downcase] = state.id
        state.cities.each do |city|
          city_key = "#{state.acronym.downcase}:#{city.name.downcase}"
          city_map[city_key] = city.id
        end
      end
      
      # Preload neighborhoods
      puts "Preloading neighborhoods..."
      neighborhood_map = {}
      Addresses::Neighborhood.find_each do |neighborhood|
        city_key = "#{neighborhood.city_id}:#{neighborhood.name.downcase}"
        neighborhood_map[city_key] = neighborhood.id
      end
      
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
      
      # Ensure all regions exist
      region_map.each do |state_acronym, region_attrs|
        region = country.regions.find_or_create_by(acronym: region_attrs[:acronym]) do |r|
          r.name = region_attrs[:name]
        end
        
        # Ensure state exists and belongs to region
        state = Addresses::State.find_by(acronym: state_acronym)
        if state && state.region_id != region.id
          state.update(region_id: region.id)
        end
      end
      
      total = `wc -l < "#{csv_path}"`.to_i
      processed = 0
      last_percent = -1
      
      puts "Processing zipcodes from #{csv_path}..."
      
      # Helper method to clean string encoding
      def self.clean_encoding(str)
        return str unless str.is_a?(String)
        # Remove invalid byte sequences
        str.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
      end

      # Process in batches
      puts "Opening CSV file with UTF-8 encoding..."
      
      # First, count total lines for progress reporting
      total_lines = `zstdcat #{csv_path.shellescape} | wc -l`.to_i
      processed = 0
      last_percent = -1
      
      begin
        # Use zstdcat to decompress and read the file
        IO.popen("zstdcat #{csv_path.shellescape}", 'r:ISO-8859-1:UTF-8') do |io|
          CSV.new(io, headers: false, col_sep: ',').each do |row|
            # Clean and normalize each field
            zipcode_number = clean_encoding(row[0].to_s.strip)
            state_acronym = clean_encoding(row[1].to_s.strip)
            city_name = clean_encoding(row[2].to_s.strip)
            neighborhood_name = clean_encoding(row[3].to_s.strip)
            street_name = clean_encoding(row[4].to_s.strip)
          
            # Skip if required fields are missing
            next if zipcode_number.blank? || state_acronym.blank? || city_name.blank?
            
            # Normalize for lookup
            state_acronym = state_acronym.to_s.upcase
            city_name = city_name.to_s.unicode_normalize(:nfd).gsub(/[^\x00-\x7F]/n, '').downcase
            neighborhood_name = neighborhood_name.to_s.unicode_normalize(:nfd).gsub(/[^\x00-\x7F]/n, '').downcase unless neighborhood_name.blank?
            
            # Find state and city
            state_id = state_map[state_acronym.downcase]
            next unless state_id
            
            city_key = "#{state_acronym.downcase}:#{city_name}"
            city_id = city_map[city_key]
            next unless city_id
            
            # Find neighborhood if present
            neighborhood_id = nil
            unless neighborhood_name.blank?
              # Normalize neighborhood name for lookup (downcase and remove accents)
              normalized_name = neighborhood_name.to_s.unicode_normalize(:nfd).gsub(/[^\x00-\x7F]/n, '').downcase
              neighborhood_key = "#{city_id}:#{normalized_name}"
              
              # Check if we've already processed this neighborhood in this batch
              unless neighborhood_id = neighborhood_map[neighborhood_key]
                # Try to find an existing neighborhood in the database with a direct query
                # First try exact match for performance
                existing = begin
                  # Try with unaccented_name first if available
                normalized = neighborhood_name.unicode_normalize(:nfd).gsub(/[^\x00-\x7F]/n, '').downcase
                if Addresses::Neighborhood.column_names.include?('unaccented_name')
                  Addresses::Neighborhood.where(
                    "unaccented_name = ? AND city_id = ?", 
                    normalized, 
                    city_id
                  ).first
                end
                rescue ActiveRecord::StatementInvalid => e
                  # Fall back to simple case-insensitive match
                  Addresses::Neighborhood.where(
                    "LOWER(name) = LOWER(?) AND city_id = ?", 
                    neighborhood_name, 
                    city_id
                  ).first
                end
                
                # If not found, try with our normalized name
                unless existing
                  existing = Addresses::Neighborhood.where(city_id: city_id).find do |n| 
                    n.name.to_s.unicode_normalize(:nfd).gsub(/[^\x00-\x7F]/n, '').downcase == normalized_name
                  end
                end
                
                if existing
                  neighborhood_id = existing.id
                  neighborhood_map[neighborhood_key] = neighborhood_id
                  next  # Skip to next iteration
                end
                
                # If we get here, we need to create a new neighborhood
                begin
                  # First double-check it doesn't exist (race condition)
                  existing = begin
                    normalized = neighborhood_name.unicode_normalize(:nfd).gsub(/[^\x00-\x7F]/n, '').downcase
                    
                    if Addresses::Neighborhood.column_names.include?('unaccented_name')
                      Addresses::Neighborhood.find_by(
                        "unaccented_name = ? AND city_id = ?", 
                        normalized, 
                        city_id
                      )
                    else
                      Addresses::Neighborhood.find_by(
                        "LOWER(name) = LOWER(?) AND city_id = ?", 
                        neighborhood_name, 
                        city_id
                      )
                    end
                  rescue ActiveRecord::StatementInvalid
                    Addresses::Neighborhood.find_by(
                      "LOWER(name) = LOWER(?) AND city_id = ?", 
                      neighborhood_name, 
                      city_id
                    )
                  end
                  
                  if existing
                    neighborhood_id = existing.id
                    neighborhood_map[neighborhood_key] = neighborhood_id
                    next
                  end
                  
                  # Create the neighborhood with proper error handling
                  neighborhood = Addresses::Neighborhood.new(
                    name: neighborhood_name.titleize,
                    city_id: city_id
                  )
                  
                  if neighborhood.save
                    neighborhood_id = neighborhood.id
                    neighborhood_map[neighborhood_key] = neighborhood_id
                    puts "[INFO] Created neighborhood: #{neighborhood_name} in city ID: #{city_id}" if ENV['DEBUG']
                  else
                    puts "[WARN] Failed to create neighborhood: #{neighborhood_name} in city ID: #{city_id} - #{neighborhood.errors.full_messages.join(', ')}"
                  end
                rescue ActiveRecord::RecordNotUnique, PG::UniqueViolation
                  # Another process created it, find it again
                  existing = begin
                    Addresses::Neighborhood.find_by(
                      "LOWER(UNACCENT(name)) = LOWER(UNACCENT(?)) AND city_id = ?", 
                      neighborhood_name, 
                      city_id
                    )
                  rescue ActiveRecord::StatementInvalid
                    Addresses::Neighborhood.find_by(
                      "LOWER(name) = LOWER(?) AND city_id = ?", 
                      neighborhood_name, 
                      city_id
                    )
                  end
                  
                  if existing
                    neighborhood_id = existing.id
                    neighborhood_map[neighborhood_key] = neighborhood_id
                  else
                    puts "[WARN] Race condition detected but couldn't find neighborhood: #{neighborhood_name} in city ID: #{city_id}"
                  end
                end
              end
            end
            
            # Prepare zipcode data for bulk insert (timestamps will be handled by the database)
            zipcode_data << {
              number: zipcode_number,
              city_id: city_id,
              neighborhood_id: neighborhood_id,
              street: street_name.presence
            }
            
            # Set state_id on the model instance if needed for validations
            # This will be used by the set_state_id callback
            Addresses::Zipcode.new(state_id: state_id) if defined?(Addresses::Zipcode)
            
            # Process in batches
            if zipcode_data.size >= batch_size
              process_zipcode_batch(zipcode_data, upsert_columns)
              processed += zipcode_data.size
              zipcode_data = []
              progress = (processed * 100) / total_lines
              if progress % 5 == 0 && progress != last_percent
                puts "Processed: #{processed}/#{total_lines} (#{progress}%)"
                last_percent = progress
              end
            end
            
            # Show progress every 10,000 records
            if processed % 10000 == 0 && processed > 0
              puts "Processed #{processed}/#{total_lines} records..."
            end
          end
        end
        
        # Process any remaining records
        unless zipcode_data.empty?
          process_zipcode_batch(zipcode_data, upsert_columns)
          processed += zipcode_data.size
        end
        
        puts "Processed: #{processed}/#{total_lines} (100%)"
      rescue => e
        puts "Error processing zipcodes: #{e.message}"
        puts e.backtrace.join("\n") if ENV['DEBUG']
        raise
      end
      
      true
    rescue => e
      puts "Error processing zipcodes: #{e.message}"
      puts e.backtrace.join("\n") if ENV['DEBUG']
      false
    end
  end
end

namespace :addresses do
  namespace :br do
    desc 'Populate all Brazilian zipcodes from official CSV'
    task zipcodes: [:environment] do
      success = Addresses::ZipcodePopulator.run
      exit(1) unless success
    rescue => e
      puts "Error processing zipcodes: #{e.message}"
      raise
    end
  end
end
