# encoding: utf-8
# This migration comes from addresses (originally 20140327171527)

class CreateAddressesCities < ActiveRecord::Migration
  def change
    create_table :addresses_cities do |t|
      t.string :name
      t.references :state, index: true

      t.timestamps
    end
  end
end
