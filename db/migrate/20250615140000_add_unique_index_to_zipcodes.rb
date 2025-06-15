# frozen_string_literal: true

class AddUniqueIndexToZipcodes < ActiveRecord::Migration[6.1]
  def change
    add_index :addresses_zipcodes, 
              [:number, :city_id, :neighborhood_id, :street], 
              unique: true,
              name: 'index_addresses_zipcodes_on_number_and_city_and_neighborhood_and_street'
  end
end
