# frozen_string_literal: true

class AddLatitudeAndLongitudeToAddressesCountry < ActiveRecord::Migration[6.0]
  def change
    add_column :addresses_countries, :latitude, :float
    add_index :addresses_countries, :latitude
    add_column :addresses_countries, :longitude, :float
    add_index :addresses_countries, :longitude
  end
end
