# encoding: utf-8

class CreateAddressesCountries < ActiveRecord::Migration
  def change
    create_table :addresses_countries do |t|
      t.string :name
      t.string :acronym

      t.timestamps
    end
  end
end
