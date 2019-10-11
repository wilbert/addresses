# frozen_string_literal: true

class AddLatitudeAndLongitudeToAddressesCities < ActiveRecord::Migration[6.0]
  def change
    add_column :addresses_cities, :latitude, :float
    add_index :addresses_cities, :latitude
    add_column :addresses_cities, :longitude, :float
    add_index :addresses_cities, :longitude
  end
end
