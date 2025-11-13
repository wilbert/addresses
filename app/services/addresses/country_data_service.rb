# frozen_string_literal: true

module Addresses
  class CountryDataService
    include ActiveModel::Model
    
    attr_accessor :verbose, :dry_run, :limit
    
    def initialize(options = {})
      @verbose = options[:verbose] || false
      @dry_run = options[:dry_run] || false
      @limit = options[:limit]
      @created_count = 0
      @skipped_count = 0
      @errors = []
    end
    
    def execute
      log_start
      
      ActiveRecord::Base.transaction do
        process_countries
        raise ActiveRecord::Rollback if @dry_run
      end
      
      log_summary
      { created: @created_count, skipped: @skipped_count, errors: @errors }
    end
    
    private
    
    def process_countries
      countries_data.each_with_index do |country_data, index|
        break if @limit && index >= @limit
        
        process_single_country(country_data)
        update_progress(index + 1, countries_data.size)
      end
    end
    
    def process_single_country(data)
      existing = Country.find_by(iso2: data[:iso2])
      
      if existing
        @skipped_count += 1
        log_skip(data[:name], "Country with ISO2 #{data[:iso2]} already exists")
        return
      end
      
      country = Country.new(data)
      
      if country.save
        @created_count += 1
        log_create(data[:name])
      else
        @errors << { country: data[:name], errors: country.errors.full_messages }
        log_error(data[:name], country.errors.full_messages)
      end
    end
    
    def countries_data
      CountrySeedData.countries_data
    end
    
    def log_start
      puts "Starting countries creation task..."
      puts "Options: #{options_summary}" if @verbose
    end
    
    def log_summary
      puts "\nTask completed successfully!"
      puts "Created: #{@created_count} countries"
      puts "Skipped: #{@skipped_count} countries"
      
      if @errors.any?
        puts "Errors encountered:"
        @errors.each do |error|
          puts "  - #{error[:country]}: #{error[:errors].join(', ')}"
        end
      end
    end
    
    def log_create(name)
      puts "Created: #{name}" if @verbose
    end
    
    def log_skip(name, reason)
      puts "Skipped: #{name} - #{reason}" if @verbose
    end
    
    def log_error(name, errors)
      puts "Error creating #{name}: #{errors.join(', ')}"
    end
    
    def update_progress(current, total)
      return unless @verbose
      
      percentage = (current.to_f / total * 100).round(2)
      print "\rProgress: #{current}/#{total} (#{percentage}%)"
      puts if current == total
    end
    
    def options_summary
      {
        verbose: @verbose,
        dry_run: @dry_run,
        limit: @limit || 'none'
      }
    end
  end
end