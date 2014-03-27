# encoding: utf-8

class CreateAddressesNeighborhoods < ActiveRecord::Migration
  def change
    create_table :addresses_neighborhoods do |t|
      t.references :city, index: true
      t.string :name

      t.timestamps
    end
  end
end
