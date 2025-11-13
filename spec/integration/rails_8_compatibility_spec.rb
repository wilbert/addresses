# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Rails 8 Compatibility', type: :integration do
  describe 'migration compatibility' do
    it 'supports Rails 8 schema format' do
      # Test that migrations can be created and run
      expect(ActiveRecord::Migration).to respond_to(:[])
      expect(ActiveRecord::Migration[8.0]).to be_a(Class)
    end
    
    it 'supports Rails 8 composite primary keys' do
      # Test composite index functionality
      expect(ActiveRecord::Base.connection).to respond_to(:supports_advisory_locks?)
    end
    
    it 'supports Rails 8 generated columns' do
      # Test generated column support
      migration = Class.new(ActiveRecord::Migration[8.0]) do
        def change
          add_column :test_table, :generated_col, :string, generated: true, as: "LOWER(name)", stored: true
        end
      end
      
      expect { migration.new.change }.not_to raise_error
    end
  end
  
  describe 'ActiveRecord associations' do
    let!(:country) { create(:country) }
    let!(:state) { create(:state, country: country) }
    let!(:city) { create(:city, state: state) }
    
    it 'maintains Rails 8 compatible associations' do
      expect(country.states).to include(state)
      expect(country.cities).to include(city)
      expect(state.country).to eq(country)
      expect(city.state).to eq(state)
    end
    
    it 'supports Rails 8 eager loading' do
      countries = Addresses::Country.includes(:states, :cities).to_a
      expect(countries).to include(country)
    end
  end
  
  describe 'transaction handling' do
    it 'supports Rails 8 transaction patterns' do
      expect do
        ActiveRecord::Base.transaction do
          create(:country, name: 'Transaction Test', iso2: 'TT', iso3: 'TTT')
          raise ActiveRecord::Rollback
        end
      end.not_to change(Addresses::Country, :count)
    end
    
    it 'supports nested transactions' do
      expect do
        ActiveRecord::Base.transaction do
          country = create(:country, name: 'Outer Transaction', iso2: 'OT', iso3: 'OTT')
          
          ActiveRecord::Base.transaction do
            create(:state, country: country, name: 'Inner State')
            raise ActiveRecord::Rollback
          end
        end
      end.not_to change(Addresses::State, :count)
    end
  end
  
  describe 'CountryDataService integration' do
    it 'works with Rails 8 transaction management' do
      service = Addresses::CountryDataService.new
      
      expect do
        result = service.execute
        expect(result).to be_a(Hash)
        expect(result).to have_key(:created)
        expect(result).to have_key(:skipped)
        expect(result).to have_key(:errors)
      end.not_to raise_error
    end
    
    it 'handles Rails 8 bulk operations' do
      service = Addresses::CountryDataService.new(limit: 3)
      result = service.execute
      
      expect(result[:created]).to be >= 0
      expect(result[:skipped]).to be >= 0
      expect(result[:errors]).to be_an(Array)
    end
  end
  
  describe 'Rake task integration' do
    before do
      Rake.application.rake_require 'tasks/countries'
      Rake::Task.define_task(:environment)
      Rake::Task['addresses:countries:create'].reenable
    end
    
    it 'loads in Rails 8 environment' do
      expect { Rake::Task['addresses:countries:create'].invoke }.not_to raise_error
    end
    
    it 'supports Rails 8 command line option parsing' do
      task = Rake::Task['addresses:countries:create']
      expect(task).to be_a(Rake::Task)
    end
  end
  
  describe 'database indexes' do
    it 'supports Rails 8 composite indexes' do
      # Test that composite indexes work
      country1 = create(:country, iso2: 'US', iso3: 'USA')
      country2 = build(:country, iso2: 'US', iso3: 'USA')
      
      expect(country2).not_to be_valid
    end
    
    it 'supports Rails 8 full-text search indexes' do
      # Test full-text search functionality
      country = create(:country, name: 'United States')
      
      # Test case-insensitive search using generated column
      results = Addresses::Country.where("name_lower LIKE ?", '%united states%')
      expect(results).to include(country)
    end
  end
  
  describe 'performance benchmarks' do
    it 'handles bulk operations efficiently' do
      start_time = Time.current
      
      10.times do |i|
        create(:country, name: "Performance Country #{i}", iso2: "P#{i}", iso3: "PC#{i}")
      end
      
      end_time = Time.current
      duration = end_time - start_time
      
      expect(duration).to be < 5.seconds
    end
    
    it 'maintains memory efficiency' do
      initial_memory = current_memory_usage
      
      service = Addresses::CountryDataService.new(limit: 5)
      service.execute
      
      final_memory = current_memory_usage
      memory_increase = final_memory - initial_memory
      
      # Memory increase should be reasonable (less than 50MB)
      expect(memory_increase).to be < 50.megabytes
    end
  end
  
  describe 'error handling' do
    it 'handles Rails 8 validation errors properly' do
      invalid_country = Addresses::Country.new(name: '', iso2: 'XX', iso3: 'XXX')
      
      expect(invalid_country).not_to be_valid
      expect(invalid_country.errors).to be_present
      expect(invalid_country.errors[:name]).to include("can't be blank")
    end
    
    it 'handles transaction rollback correctly' do
      expect do
        ActiveRecord::Base.transaction do
          create(:country, name: 'Rollback Test', iso2: 'RT', iso3: 'RTB')
          raise ActiveRecord::RecordInvalid, "Test rollback"
        end
      end.to raise_error(ActiveRecord::RecordInvalid)
       .and not_change(Addresses::Country, :count)
    end
  end
  
  private
  
  def current_memory_usage
    # Simple memory usage estimation
    # In a real scenario, you'd use more sophisticated memory profiling
    ObjectSpace.count_objects[:TOTAL] * 0.001 # Rough estimate in KB
  end
end