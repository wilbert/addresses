# frozen_string_literal: true

class AddIndexesToRegions < ActiveRecord::Migration[6.0]
  def change
    add_index :addresses_regions, :name
    add_index :addresses_regions, [:name, :country_id]
  end
end
