# frozen_string_literal: true

require_relative '../../../addresses/compression_utils'

namespace :addresses do
  namespace :br do
    desc 'Populate Brazilian regions'
    task regions: :environment do
      puts 'Populating Brazilian regions...'
      
      regions_path = File.join(Addresses::Engine.root, 'spec/fixtures/zipcodes/br/regions.csv.zst')
      
      begin
        # Decompress the file if needed
        csv_path = Addresses::CompressionUtils.decompress_if_needed(regions_path)
        
        unless File.exist?(csv_path)
          puts "Error: Could not find regions.csv.zst at #{regions_path}"
          next
        end
        
        require 'csv'
        
        created = 0
        updated = 0
        
        CSV.foreach(csv_path, headers: true) do |row|
          region = Addresses::Region.find_or_initialize_by(id: row['id'])
          
          region_attributes = {
            name: row['name'],
            acronym: row['acronym'],
            country_id: row['country_id']
          }
          
          if region.new_record?
            region.assign_attributes(region_attributes)
            if region.save
              created += 1
              print '.' if (created % 1).zero? # Show progress for each region
            else
              puts "\nError creating region #{row['name']}: #{region.errors.full_messages.join(', ')}"
            end
          elsif region.changed_attributes.any? { |k, v| region_attributes[k.to_sym] && region_attributes[k.to_sym].to_s != v.to_s }
            if region.update(region_attributes)
              updated += 1
            else
              puts "\nError updating region #{row['name']}: #{region.errors.full_messages.join(', ')}"
            end
          end
        end
        
        # Clean up the decompressed CSV file if it was created by us
        if defined?(csv_path) && csv_path != regions_path
          Addresses::CompressionUtils.cleanup_decompressed(csv_path)
        end
        
        puts "\nRegions population complete!"
        puts "- Created: #{created}"
        puts "- Updated: #{updated}"
        puts "Total regions in database: #{Addresses::Region.count}"
      rescue => e
        puts "\nError: #{e.message}"
        puts e.backtrace.join("\n")
        raise
      end
    end
  end
end

# Add to the main addresses:br:all task if it exists
Rake::Task['addresses:br:all'].enhance(['addresses:br:regions']) if Rake::Task.task_defined?('addresses:br:all')
