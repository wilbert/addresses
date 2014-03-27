# encoding: utf-8
# This migration comes from addresses (originally 20140327141509)

class CreateAddressesCountries < ActiveRecord::Migration
  def change
    create_table :addresses_countries do |t|
      t.string :name
      t.string :acronym

      t.timestamps
    end
  end
end
