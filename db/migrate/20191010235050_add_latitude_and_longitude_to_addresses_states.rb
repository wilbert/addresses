# frozen_string_literal: true

class AddLatitudeAndLongitudeToAddressesStates < ActiveRecord::Migration[6.0]
  def change
    add_column :addresses_states, :latitude, :float
    add_index :addresses_states, :latitude
    add_column :addresses_states, :longitude, :float
    add_index :addresses_states, :longitude
  end
end
