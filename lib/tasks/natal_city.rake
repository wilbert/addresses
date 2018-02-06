namespace :addresses do
  desc 'Creates neighborhood, city, state and country for Natal/RN'
  task :'city:natal' => [:environment] do
    # Country
    Addresses::Country.create(id: '33', name: 'Brasil', acronym: 'BRA') 

    # State
    Addresses::State.create(id: '47', name: 'Rio Grande do Norte', acronym: 'RN', country_id: 33)

    # City
    Addresses::City.create(id: '9346', name: 'Natal', state_id: 47)

    # Neighborhood
    Addresses::Neighborhood.create(id: 10626, city_id: 9346, name: 'Alecrim')
    Addresses::Neighborhood.create(id: 10627, city_id: 9346, name: 'Areia Preta')
    Addresses::Neighborhood.create(id: 10628, city_id: 9346, name: 'Barro Vermelho')
    Addresses::Neighborhood.create(id: 10629, city_id: 9346, name: 'Bom Pastor')
    Addresses::Neighborhood.create(id: 10630, city_id: 9346, name: 'Candelária')
    Addresses::Neighborhood.create(id: 10631, city_id: 9346, name: 'Capim Macio')
    Addresses::Neighborhood.create(id: 10632, city_id: 9346, name: 'Cidade Alta')
    Addresses::Neighborhood.create(id: 10633, city_id: 9346, name: 'Cidade da Esperança')
    Addresses::Neighborhood.create(id: 10634, city_id: 9346, name: 'Cidade Nova')
    Addresses::Neighborhood.create(id: 10635, city_id: 9346, name: 'Dix-Sept Rosado')
    Addresses::Neighborhood.create(id: 10636, city_id: 9346, name: 'Felipe Camarão')
    Addresses::Neighborhood.create(id: 10637, city_id: 9346, name: 'Guarapes')
    Addresses::Neighborhood.create(id: 10638, city_id: 9346, name: 'Igapó')
    Addresses::Neighborhood.create(id: 10639, city_id: 9346, name: 'Lagoa Azul')
    Addresses::Neighborhood.create(id: 10640, city_id: 9346, name: 'Lagoa Nova')
    Addresses::Neighborhood.create(id: 10641, city_id: 9346, name: 'Lagoa Seca')
    Addresses::Neighborhood.create(id: 10642, city_id: 9346, name: 'Mãe Luiza')
    Addresses::Neighborhood.create(id: 10643, city_id: 9346, name: 'Neópolis')
    Addresses::Neighborhood.create(id: 10644, city_id: 9346, name: 'Nordeste')
    Addresses::Neighborhood.create(id: 10645, city_id: 9346, name: 'Nossa Senhora da Apresentação')
    Addresses::Neighborhood.create(id: 10646, city_id: 9346, name: 'Nossa Senhora de Nazaré')
    Addresses::Neighborhood.create(id: 10647, city_id: 9346, name: 'Nova Descoberta')
    Addresses::Neighborhood.create(id: 10648, city_id: 9346, name: 'Pajuçara')
    Addresses::Neighborhood.create(id: 10649, city_id: 9346, name: 'Petrópolis')
    Addresses::Neighborhood.create(id: 10650, city_id: 9346, name: 'Pitimbu')
    Addresses::Neighborhood.create(id: 10651, city_id: 9346, name: 'Ponta Negra')
    Addresses::Neighborhood.create(id: 10652, city_id: 9346, name: 'Potengi')
    Addresses::Neighborhood.create(id: 10653, city_id: 9346, name: 'Praia do Meio')
    Addresses::Neighborhood.create(id: 10654, city_id: 9346, name: 'Quintas')
    Addresses::Neighborhood.create(id: 10655, city_id: 9346, name: 'Redinha')
    Addresses::Neighborhood.create(id: 10656, city_id: 9346, name: 'Ribeira')
    Addresses::Neighborhood.create(id: 10657, city_id: 9346, name: 'Rocas')
    Addresses::Neighborhood.create(id: 10658, city_id: 9346, name: 'Salinas')
    Addresses::Neighborhood.create(id: 10659, city_id: 9346, name: 'Santos Reis')
    Addresses::Neighborhood.create(id: 10660, city_id: 9346, name: 'Tirol')
  end
end
