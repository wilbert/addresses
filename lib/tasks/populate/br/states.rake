# encoding: utf-8

namespace :br do
  desc 'Populate Brazilian States'
  task states: [:environment] do
    puts 'Populating States'
    Addresses::State.find_or_create_by(id: '1', name: 'Acre', acronym: 'AC', country_id: 26)
    Addresses::State.find_or_create_by(id: '2', name: 'Alagoas', acronym: 'AL', country_id: 26)
    Addresses::State.find_or_create_by(id: '3', name: 'Amazonas', acronym: 'AM', country_id: 26)
    Addresses::State.find_or_create_by(id: '4', name: 'Amapá', acronym: 'AP', country_id: 26)
    Addresses::State.find_or_create_by(id: '5', name: 'Bahia', acronym: 'BA', country_id: 26)
    Addresses::State.find_or_create_by(id: '6', name: 'Ceará', acronym: 'CE', country_id: 26)
    Addresses::State.find_or_create_by(id: '7', name: 'Brasília', acronym: 'DF', country_id: 26)
    Addresses::State.find_or_create_by(id: '8', name: 'Espírito Santo', acronym: 'ES', country_id: 26)
    Addresses::State.find_or_create_by(id: '9', name: 'Goiás', acronym: 'GO', country_id: 26)
    Addresses::State.find_or_create_by(id: '10', name: 'Maranhão', acronym: 'MA', country_id: 26)
    Addresses::State.find_or_create_by(id: '11', name: 'Minas Gerais', acronym: 'MG', country_id: 26)
    Addresses::State.find_or_create_by(id: '12', name: 'Mato Grosso do Sul', acronym: 'MS', country_id: 26)
    Addresses::State.find_or_create_by(id: '13', name: 'Mato Grosso', acronym: 'MT', country_id: 26)
    Addresses::State.find_or_create_by(id: '14', name: 'Pará', acronym: 'PA', country_id: 26)
    Addresses::State.find_or_create_by(id: '15', name: 'Paraíba', acronym: 'PB', country_id: 26)
    Addresses::State.find_or_create_by(id: '16', name: 'Pernambuco', acronym: 'PE', country_id: 26)
    Addresses::State.find_or_create_by(id: '17', name: 'Piauí', acronym: 'PI', country_id: 26)
    Addresses::State.find_or_create_by(id: '18', name: 'Paraná', acronym: 'PR', country_id: 26)
    Addresses::State.find_or_create_by(id: '19', name: 'Rio de Janeiro', acronym: 'RJ', country_id: 26)
    Addresses::State.find_or_create_by(id: '20', name: 'Rio Grande do Norte', acronym: 'RN', country_id: 26)
    Addresses::State.find_or_create_by(id: '21', name: 'Rondônia', acronym: 'RO', country_id: 26)
    Addresses::State.find_or_create_by(id: '22', name: 'Roraima', acronym: 'RR', country_id: 26)
    Addresses::State.find_or_create_by(id: '23', name: 'Rio Grande do Sul', acronym: 'RS', country_id: 26)
    Addresses::State.find_or_create_by(id: '24', name: 'Santa Catarina', acronym: 'SC', country_id: 26)
    Addresses::State.find_or_create_by(id: '25', name: 'Sergipe', acronym: 'SE', country_id: 26)
    Addresses::State.find_or_create_by(id: '26', name: 'São Paulo', acronym: 'SP', country_id: 26)
    Addresses::State.find_or_create_by(id: '27', name: 'Tocantins', acronym: 'TO', country_id: 26)
  end
end
