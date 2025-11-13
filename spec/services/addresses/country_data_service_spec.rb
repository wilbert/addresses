# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Addresses::CountryDataService, type: :service do
  let(:service) { described_class.new(options) }
  let(:options) { {} }
  
  describe '#initialize' do
    context 'with default options' do
      it 'sets default values' do
        expect(service.verbose).to be false
        expect(service.dry_run).to be false
        expect(service.limit).to be_nil
      end
    end
    
    context 'with custom options' do
      let(:options) { { verbose: true, dry_run: true, limit: 5 } }
      
      it 'sets custom values' do
        expect(service.verbose).to be true
        expect(service.dry_run).to be true
        expect(service.limit).to eq(5)
      end
    end
  end
  
  describe '#execute' do
    let(:result) { service.execute }
    
    context 'with valid data' do
      before do
        allow(Addresses::CountrySeedData).to receive(:countries_data).and_return([
          { name: 'Test Country', iso2: 'TC', iso3: 'TCY', capital: 'Test City', currency: 'TST', phone_code: '+1' }
        ])
      end
      
      it 'creates new countries' do
        expect { result }.to change(Addresses::Country, :count).by(1)
        expect(result[:created]).to eq(1)
        expect(result[:skipped]).to eq(0)
        expect(result[:errors]).to be_empty
      end
      
      it 'outputs progress information' do
        expect { result }.to output(/Task completed successfully!/).to_stdout
      end
    end
    
    context 'with duplicate countries' do
      let!(:existing_country) { create(:country, name: 'Test Country', iso2: 'TC', iso3: 'TCY') }
      
      before do
        allow(Addresses::CountrySeedData).to receive(:countries_data).and_return([
          { name: 'Test Country', iso2: 'TC', iso3: 'TCY', capital: 'Test City', currency: 'TST', phone_code: '+1' }
        ])
      end
      
      it 'skips duplicate countries' do
        expect { result }.not_to change(Addresses::Country, :count)
        expect(result[:created]).to eq(0)
        expect(result[:skipped]).to eq(1)
      end
    end
    
    context 'with invalid data' do
      before do
        allow(Addresses::CountrySeedData).to receive(:countries_data).and_return([
          { name: '', iso2: 'TC', iso3: 'TCY' } # Invalid: empty name
        ])
      end
      
      it 'handles validation errors gracefully' do
        expect { result }.not_to change(Addresses::Country, :count)
        expect(result[:created]).to eq(0)
        expect(result[:errors]).not_to be_empty
      end
    end
    
    context 'with dry_run option' do
      let(:options) { { dry_run: true } }
      
      before do
        allow(Addresses::CountrySeedData).to receive(:countries_data).and_return([
          { name: 'Test Country', iso2: 'TC', iso3: 'TCY', capital: 'Test City', currency: 'TST', phone_code: '+1' }
        ])
      end
      
      it 'does not create records in dry-run mode' do
        expect { result }.not_to change(Addresses::Country, :count)
        expect(result[:created]).to eq(1) # Should show what would be created
      end
    end
    
    context 'with limit option' do
      let(:options) { { limit: 2 } }
      
      before do
        allow(Addresses::CountrySeedData).to receive(:countries_data).and_return([
          { name: 'Country 1', iso2: 'C1', iso3: 'CY1' },
          { name: 'Country 2', iso2: 'C2', iso3: 'CY2' },
          { name: 'Country 3', iso2: 'C3', iso3: 'CY3' }
        ])
      end
      
      it 'processes only the specified number of countries' do
        expect { result }.to change(Addresses::Country, :count).by(2)
        expect(result[:created]).to eq(2)
      end
    end
    
    context 'with verbose option' do
      let(:options) { { verbose: true } }
      
      before do
        allow(Addresses::CountrySeedData).to receive(:countries_data).and_return([
          { name: 'Test Country', iso2: 'TC', iso3: 'TCY' }
        ])
      end
      
      it 'outputs detailed progress information' do
        expect { result }.to output(/Starting countries creation task/).to_stdout
        expect { result }.to output(/Created: Test Country/).to_stdout
        expect { result }.to output(/Progress: 1\/1/).to_stdout
      end
    end
    
    context 'transaction rollback' do
      before do
        allow(Addresses::CountrySeedData).to receive(:countries_data).and_return([
          { name: 'Valid Country', iso2: 'VC', iso3: 'VCY' },
          { name: '', iso2: 'IC', iso3: 'ICY' } # Invalid: empty name
        ])
      end
      
      it 'rolls back all changes when an error occurs' do
        expect { result }.not_to change(Addresses::Country, :count)
        expect(result[:errors]).not_to be_empty
      end
    end
  end
  
  describe 'Rails 8 compatibility' do
    it 'works with Rails 8 transaction handling' do
      expect(ActiveRecord::Base).to receive(:transaction).and_call_original
      service.execute
    end
    
    it 'supports Rails 8 error handling patterns' do
      allow(Addresses::CountrySeedData).to receive(:countries_data).and_return([
        { name: '', iso2: 'IC', iso3: 'ICY' } # Invalid data
      ])
      
      result = service.execute
      expect(result[:errors]).to be_an(Array)
      expect(result[:errors].first).to include(:country, :errors)
    end
  end
  
  describe 'performance' do
    it 'handles bulk operations efficiently' do
      countries = Array.new(10) do |i|
        { name: "Country #{i}", iso2: "C#{i}", iso3: "CY#{i}" }
      end
      
      allow(Addresses::CountrySeedData).to receive(:countries_data).and_return(countries)
      
      start_time = Time.current
      result = service.execute
      end_time = Time.current
      
      expect(result[:created]).to eq(10)
      expect(end_time - start_time).to be < 5.seconds # Should complete within 5 seconds
    end
  end
end