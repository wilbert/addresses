# encoding: utf-8

namespace :br do
  desc 'Populate Brazilian Zipcodes'
  task zipcodes: [:environment] do
    puts 'Populating Zipcodes'
    File.readlines("#{Addresses::Engine.root}/fixtures/zipcodes/br/ceps.txt").each do |line|
      zipcode_number, city_state, neighborhood_name, street_name = line.split(/\t/)

      city_name = city_state.strip.split('/')[0]
      state_acronym = city_state.split('/')[1][0..1]

      next unless Addresses::Zipcode.find_by(number: zipcode_number.strip).nil?

      state = Addresses::State.find_by(acronym: state_acronym)

      city = state.cities.find_or_create_by(name: city_name)

      unless neighborhood_name.blank?
        neighborhood = city.neighborhoods.find_by(name: neighborhood_name.strip)
        neighborhood = city.neighborhoods.create!(name: neighborhood_name) if neighborhood.nil?
      end

      zipcode = Addresses::Zipcode.new
      zipcode.city_id = city.id
      zipcode.neighborhood_id = neighborhood.try(:id)
      zipcode.street = street_name.strip
      zipcode.number = zipcode_number.strip

      if zipcode.valid?
        zipcode.save!
      else
        puts "#{zipcode.inspect} invalid"
        next
      end
    end
  end
end
