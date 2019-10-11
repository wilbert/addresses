# frozen_string_literal: true

class AddLatitudeAndLongitudeToAddressesAddress < ActiveRecord::Migration[6.0]
  def change
    add_column :addresses_addresses, :latitude, :float
    add_index :addresses_addresses, :latitude
    add_column :addresses_addresses, :longitude, :float
    add_index :addresses_addresses, :longitude
  end
end
