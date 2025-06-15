namespace :test do
  task :hello do
    puts "Hello from test task!"
    puts "Current directory: #{Dir.pwd}"
    
    # Try to find ceps.csv in a few locations
    possible_paths = [
      'spec/fixtures/zipcodes/br/ceps.csv',
      'test/fixtures/zipcodes/br/ceps.csv',
      'zipcodes/br/ceps.csv'
    ]
    
    found = false
    possible_paths.each do |path|
      if File.exist?(path)
        puts "Found ceps.csv at: #{File.expand_path(path)}"
        found = true
        break
      end
    end
    
    puts "ceps.csv not found in any of the expected locations" unless found
  end
end
