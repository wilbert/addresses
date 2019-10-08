# encoding: utf-8
# frozen_string_literal: true

class CreateAddressesCities < ActiveRecord::Migration[4.2]
  def change
    create_table :addresses_cities do |t|
      t.string :name
      t.references :state, index: true

      t.timestamps
    end
  end
end
