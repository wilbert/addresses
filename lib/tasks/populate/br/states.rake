# encoding: utf-8
# frozen_string_literal: true

namespace :addresses do
  namespace :br do
    def update_or_create_state(id, name, acronym, region_id)
      state = Addresses::State.find_by(id: id)
      if state
        state.update!(
          name: name,
          acronym: acronym,
          country_id: 26,
          region_id: region_id
        )
        print 'u' # Updated
      else
        Addresses::State.create!(
          id: id,
          name: name,
          acronym: acronym,
          country_id: 26,
          region_id: region_id
        )
        print '.' # Created
      end
    end
    
    desc 'Populate all Brazilian states'
    task states: [:environment] do
      puts 'Populating States...'
      
      # First, ensure regions are populated
      Rake::Task['addresses:br:regions'].invoke
      
      # North Region (1)
      update_or_create_state('1', 'Acre', 'AC', 1)
      update_or_create_state('3', 'Amazonas', 'AM', 1)
      update_or_create_state('4', 'Amapá', 'AP', 1)
      update_or_create_state('14', 'Pará', 'PA', 1)
      update_or_create_state('21', 'Rondônia', 'RO', 1)
      update_or_create_state('22', 'Roraima', 'RR', 1)
      update_or_create_state('27', 'Tocantins', 'TO', 1)
      
      # Northeast Region (2)
      update_or_create_state('2', 'Alagoas', 'AL', 2)
      update_or_create_state('5', 'Bahia', 'BA', 2)
      update_or_create_state('6', 'Ceará', 'CE', 2)
      update_or_create_state('10', 'Maranhão', 'MA', 2)
      update_or_create_state('15', 'Paraíba', 'PB', 2)
      update_or_create_state('16', 'Pernambuco', 'PE', 2)
      update_or_create_state('17', 'Piauí', 'PI', 2)
      update_or_create_state('20', 'Rio Grande do Norte', 'RN', 2)
      update_or_create_state('25', 'Sergipe', 'SE', 2)
      
      # Center-West Region (3)
      update_or_create_state('7', 'Distrito Federal', 'DF', 3)
      update_or_create_state('9', 'Goiás', 'GO', 3)
      update_or_create_state('12', 'Mato Grosso do Sul', 'MS', 3)
      update_or_create_state('13', 'Mato Grosso', 'MT', 3)
      
      # Southeast Region (4)
      update_or_create_state('8', 'Espírito Santo', 'ES', 4)
      update_or_create_state('11', 'Minas Gerais', 'MG', 4)
      update_or_create_state('19', 'Rio de Janeiro', 'RJ', 4)
      update_or_create_state('26', 'São Paulo', 'SP', 4)
      
      # South Region (5)
      update_or_create_state('18', 'Paraná', 'PR', 5)
      update_or_create_state('23', 'Rio Grande do Sul', 'RS', 5)
      update_or_create_state('24', 'Santa Catarina', 'SC', 5)
      
      puts "States population complete! Total states: #{Addresses::State.count}"
    end
  end
end