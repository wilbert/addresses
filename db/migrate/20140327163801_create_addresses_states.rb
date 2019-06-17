# encoding: utf-8

class CreateAddressesStates < ActiveRecord::Migration[4.2]
  def change
    create_table :addresses_states do |t|
      t.string :name
      t.string :acronym
      t.references :country, index: true

      t.timestamps
    end
  end
end
