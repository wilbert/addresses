# frozen_string_literal: true

require 'rails_helper'
require 'rake'

RSpec.describe 'addresses:countries:create', type: :task do
  before do
    Rake.application.rake_require 'tasks/countries'
    Rake::Task.define_task(:environment)
    Rake::Task['addresses:countries:create'].reenable
  end
  
  let(:task) { Rake::Task['addresses:countries:create'] }
  
  describe 'task execution' do
    before do
      allow(Addresses::CountryDataService).to receive(:new).and_return(service)
      allow(service).to receive(:execute).and_return({ created: 1, skipped: 0, errors: [] })
    end
    
    let(:service) { instance_double(Addresses::CountryDataService) }
    
    it 'executes the CountryDataService' do
      expect(service).to receive(:execute)
      task.invoke
    end
    
    it 'outputs completion message' do
      expect { task.invoke }.to output(/Task completed successfully!/).to_stdout
    end
    
    it 'displays creation statistics' do
      expect { task.invoke }.to output(/Created: 1 countries/).to_stdout
      expect { task.invoke }.to output(/Skipped: 0 countries/).to_stdout
    end
  end
  
  describe 'command line options' do
    let(:service) { instance_double(Addresses::CountryDataService) }
    
    before do
      allow(Addresses::CountryDataService).to receive(:new).and_return(service)
      allow(service).to receive(:execute).and_return({ created: 1, skipped: 0, errors: [] })
    end
    
    context 'with --verbose flag' do
      before do
        ARGV.replace(['--verbose'])
      end
      
      after do
        ARGV.clear
      end
      
      it 'passes verbose option to service' do
        expect(Addresses::CountryDataService).to receive(:new).with(hash_including(verbose: true))
        task.invoke
      end
    end
    
    context 'with --dry-run flag' do
      before do
        ARGV.replace(['--dry-run'])
      end
      
      after do
        ARGV.clear
      end
      
      it 'passes dry_run option to service' do
        expect(Addresses::CountryDataService).to receive(:new).with(hash_including(dry_run: true))
        task.invoke
      end
    end
    
    context 'with --limit option' do
      before do
        ARGV.replace(['--limit', '5'])
      end
      
      after do
        ARGV.clear
      end
      
      it 'passes limit option to service' do
        expect(Addresses::CountryDataService).to receive(:new).with(hash_including(limit: 5))
        task.invoke
      end
    end
    
    context 'with --help flag' do
      before do
        ARGV.replace(['--help'])
      end
      
      after do
        ARGV.clear
      end
      
      it 'displays help message and exits' do
        expect { task.invoke }.to output(/Usage: rails addresses:countries:create/).to_stdout
          .and raise_error(SystemExit)
      end
    end
  end
  
  describe 'error handling' do
    let(:service) { instance_double(Addresses::CountryDataService) }
    
    before do
      allow(Addresses::CountryDataService).to receive(:new).and_return(service)
      allow(service).to receive(:execute).and_return({ 
        created: 0, 
        skipped: 1, 
        errors: [{ country: 'Test Country', errors: ['Name cannot be blank'] }] 
      })
    end
    
    it 'displays error messages' do
      expect { task.invoke }.to output(/Errors encountered:/).to_stdout
      expect { task.invoke }.to output(/Test Country: Name cannot be blank/).to_stdout
    end
    
    it 'shows skipped countries count' do
      expect { task.invoke }.to output(/Skipped: 1 countries/).to_stdout
    end
  end
  
  describe 'Rails 8 compatibility' do
    it 'loads in Rails 8 environment' do
      expect { task.invoke }.not_to raise_error
    end
    
    it 'uses Rails 8 task loading patterns' do
      expect(Rake.application).to respond_to(:rake_require)
      expect(Rake::Task).to respond_to(:define_task)
    end
  end
  
  describe 'integration with CountryDataService' do
    it 'properly integrates with the service layer' do
      service = instance_double(Addresses::CountryDataService)
      expect(Addresses::CountryDataService).to receive(:new).and_return(service)
      expect(service).to receive(:execute)
      
      task.invoke
    end
  end
end