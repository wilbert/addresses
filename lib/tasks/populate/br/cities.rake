# encoding: utf-8

require 'csv'

desc 'Popula todas as cidades do Brasil a partir do CSV oficial do IBGE'
namespace :br do
  task cities: [:environment] do
    puts 'Populando cidades do Brasil a partir do CSV...'
    csv_path = File.expand_path('../../../../spec/fixtures/municipios.csv', __dir__)

    # Read file as binary and force UTF-8 encoding, replacing invalid chars
    raw = File.open(csv_path, 'rb') { |f| f.read }
    utf8 = raw.encode('UTF-8', invalid: :replace, undef: :replace, replace: '')

    # Build a map of state acronyms to state IDs
    state_map = Addresses::State.where(country_id: 26).pluck(:acronym, :id).to_h

    created = 0
    CSV.parse(utf8, headers: true, col_sep: ';') do |row|
      city_name = row[3].to_s.strip # MUNICÍPIO - IBGE
      state_acronym = row[4].to_s.strip # UF
      state_id = state_map[state_acronym]
      next unless state_id

      city = Addresses::City.find_or_create_by(name: city_name, state_id: state_id)
      created += 1 if city.persisted?
    end
    puts "Cidades criadas ou encontradas: #{created}"
  end
end
