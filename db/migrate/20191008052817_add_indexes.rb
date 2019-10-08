# frozen_string_literal: true

class AddIndexes < ActiveRecord::Migration[6.0]
  def change
    add_index :addresses_neighborhoods, :name
    add_index :addresses_neighborhoods, [:name, :city_id]

    add_index :addresses_countries, :name
    add_index :addresses_countries, :acronym

    add_index :addresses_cities, :name
    add_index :addresses_cities, [:name, :state_id]

    add_index :addresses_states, :name
    add_index :addresses_states, [:name, :country_id]

    add_index :addresses_zipcodes, :number

    add_index :addresses_addresses, [:addressable_id, :addressable_type], name: :index_addresses_addressable
  end
end
