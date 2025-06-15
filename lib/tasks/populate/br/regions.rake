# frozen_string_literal: true

namespace :addresses do
  namespace :br do
    desc 'Populate Brazilian regions'
    task regions: :environment do
      puts 'Populating Brazilian regions...'
      
      regions_path = File.expand_path('../../../../spec/fixtures/zipcodes/br/regions.csv', __dir__)
      
      unless File.exist?(regions_path)
        puts "Error: Could not find regions.csv at #{regions_path}"
        next
      end
      
      require 'csv'
      
      created = 0
      updated = 0
      
      CSV.foreach(regions_path, headers: true) do |row|
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
      
      puts "\nRegions population complete!"
      puts "- Created: #{created}"
      puts "- Updated: #{updated}"
      puts "Total regions in database: #{Addresses::Region.count}"
    end
  end
end

# Add to the main addresses:br:all task if it exists
Rake::Task['addresses:br:all'].enhance(['addresses:br:regions']) if Rake::Task.task_defined?('addresses:br:all')
