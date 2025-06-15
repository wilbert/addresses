# frozen_string_literal: true

# This migration comes from addresses (originally 20250615135200)
class AddUniqueIndexToNeighborhoods < ActiveRecord::Migration[6.1]
  def change
    # Remove any existing duplicates first
    execute <<-SQL.squish
      DELETE FROM addresses_neighborhoods a
      WHERE a.id NOT IN (
        SELECT MIN(b.id)
        FROM addresses_neighborhoods b
        GROUP BY LOWER(b.name), b.city_id
      )
    SQL

    # Add the unique index
    add_index :addresses_neighborhoods, 'LOWER(name), city_id',
              unique: true,
              name: 'index_addresses_neighborhoods_on_lower_name_and_city_id'
  end
end
