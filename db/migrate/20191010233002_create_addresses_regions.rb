# frozen_string_literal: true

class CreateAddressesRegions < ActiveRecord::Migration[6.0]
  def change
    create_table :addresses_regions do |t|
      t.string :name
      t.string :acronym
      t.float :latitude
      t.float :longitude
      t.references :country, index: true

      t.timestamps
    end
  end
end
