# frozen_string_literal: true

class AddLatitudeAndLongitudeToAddressesNeighborhoods < ActiveRecord::Migration[6.0]
  def change
    add_column :addresses_neighborhoods, :latitude, :float
    add_index :addresses_neighborhoods, :latitude
    add_column :addresses_neighborhoods, :longitude, :float
    add_index :addresses_neighborhoods, :longitude
  end
end
