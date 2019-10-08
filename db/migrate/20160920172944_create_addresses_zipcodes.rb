# frozen_string_literal: true

class CreateAddressesZipcodes < ActiveRecord::Migration[5.0]
  def change
    create_table :addresses_zipcodes do |t|
      t.string :street
      t.references :city, index: true
      t.references :neighborhood, index: true
      t.string :number

      t.timestamps
    end
  end
end
