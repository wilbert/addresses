# encoding: utf-8

namespace :br do
  desc 'Populate Brazilian States'
  task states: [:environment] do
    puts 'Populating States'
    Addresses::State.find_or_create_by(id: '28', name: 'Acre', acronym: 'AC', country_id: 33)
    Addresses::State.find_or_create_by(id: '29', name: 'Alagoas', acronym: 'AL', country_id: 33)
    Addresses::State.find_or_create_by(id: '30', name: 'Amazonas', acronym: 'AM', country_id: 33)
    Addresses::State.find_or_create_by(id: '31', name: 'Amapá', acronym: 'AP', country_id: 33)
    Addresses::State.find_or_create_by(id: '32', name: 'Bahia', acronym: 'BA', country_id: 33)
    Addresses::State.find_or_create_by(id: '33', name: 'Ceará', acronym: 'CE', country_id: 33)
    Addresses::State.find_or_create_by(id: '34', name: 'Brasília', acronym: 'DF', country_id: 33)
    Addresses::State.find_or_create_by(id: '35', name: 'Espírito Santo', acronym: 'ES', country_id: 33)
    Addresses::State.find_or_create_by(id: '36', name: 'Goiás', acronym: 'GO', country_id: 33)
    Addresses::State.find_or_create_by(id: '37', name: 'Maranhão', acronym: 'MA', country_id: 33)
    Addresses::State.find_or_create_by(id: '38', name: 'Minas Gerais', acronym: 'MG', country_id: 33)
    Addresses::State.find_or_create_by(id: '39', name: 'Mato Grosso do Sul', acronym: 'MS', country_id: 33)
    Addresses::State.find_or_create_by(id: '40', name: 'Mato Grosso', acronym: 'MT', country_id: 33)
    Addresses::State.find_or_create_by(id: '41', name: 'Pará', acronym: 'PA', country_id: 33)
    Addresses::State.find_or_create_by(id: '42', name: 'Paraíba', acronym: 'PB', country_id: 33)
    Addresses::State.find_or_create_by(id: '43', name: 'Pernambuco', acronym: 'PE', country_id: 33)
    Addresses::State.find_or_create_by(id: '44', name: 'Piauí', acronym: 'PI', country_id: 33)
    Addresses::State.find_or_create_by(id: '45', name: 'Paraná', acronym: 'PR', country_id: 33)
    Addresses::State.find_or_create_by(id: '46', name: 'Rio de Janeiro', acronym: 'RJ', country_id: 33)
    Addresses::State.find_or_create_by(id: '47', name: 'Rio Grande do Norte', acronym: 'RN', country_id: 33)
    Addresses::State.find_or_create_by(id: '48', name: 'Rondônia', acronym: 'RO', country_id: 33)
    Addresses::State.find_or_create_by(id: '49', name: 'Roraima', acronym: 'RR', country_id: 33)
    Addresses::State.find_or_create_by(id: '50', name: 'Rio Grande do Sul', acronym: 'RS', country_id: 33)
    Addresses::State.find_or_create_by(id: '51', name: 'Santa Catarina', acronym: 'SC', country_id: 33)
    Addresses::State.find_or_create_by(id: '52', name: 'Sergipe', acronym: 'SE', country_id: 33)
    Addresses::State.find_or_create_by(id: '53', name: 'São Paulo', acronym: 'SP', country_id: 33)
    Addresses::State.find_or_create_by(id: '54', name: 'Tocantins', acronym: 'TO', country_id: 33)
  end
end
