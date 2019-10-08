class AddIndexes < ActiveRecord::Migration[6.0]
  def change
    add_index :neighborhoods, :name
    add_index :neighborhoods, [:name, :city_id]

    add_index :countries, :name
    add_index :countries, :acronym

    add_index :cities, :name
    add_index :cities, [:name, :state_id]

    add_index :states, :name
    add_index :state, [:name, :country_id]

    add_index :zipcodes, :number

    add_index :addresses, [:addressable_id, :addressable_type]
  end
end
