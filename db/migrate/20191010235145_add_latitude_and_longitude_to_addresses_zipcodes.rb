# frozen_string_literal: true

class AddLatitudeAndLongitudeToAddressesZipcodes < ActiveRecord::Migration[6.0]
  def change
    add_column :addresses_zipcodes, :latitude, :float
    add_index :addresses_zipcodes, :latitude
    add_column :addresses_zipcodes, :longitude, :float
    add_index :addresses_zipcodes, :longitude
  end
end
