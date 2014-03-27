# encoding: utf-8
# This migration comes from addresses (originally 20140327163801)

class CreateAddressesStates < ActiveRecord::Migration
  def change
    create_table :addresses_states do |t|
      t.string :name
      t.string :acronym
      t.references :country, index: true

      t.timestamps
    end
  end
end
