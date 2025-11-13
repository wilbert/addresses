# frozen_string_literal: true

require 'optparse'

namespace :addresses do
  namespace :countries do
    desc "Create country records from predefined seed data"
    task create: :environment do
      options = {}
      
      # Parse command line options
      OptionParser.new do |opts|
        opts.banner = "Usage: rails addresses:countries:create [options]"
        
        opts.on("-v", "--verbose", "Run verbosely") do |v|
          options[:verbose] = v
        end
        
        opts.on("-d", "--dry-run", "Preview without making changes") do |d|
          options[:dry_run] = d
        end
        
        opts.on("-l", "--limit N", Integer, "Limit number of countries to process") do |l|
          options[:limit] = l
        end
        
        opts.on("-h", "--help", "Show this help message") do
          puts opts
          exit
        end
      end.parse!
      
      puts "Starting countries creation task..."
      puts "Options: #{options.inspect}" if options[:verbose]
      
      service = Addresses::CountryDataService.new(options)
      result = service.execute
      
      puts "\nTask completed successfully!"
      puts "Created: #{result[:created]} countries"
      puts "Skipped: #{result[:skipped]} countries"
      
      if result[:errors].any?
        puts "Errors encountered:"
        result[:errors].each do |error|
          puts "  - #{error[:country]}: #{error[:errors].join(', ')}"
        end
      end
    end
  end
end