# frozen_string_literal: true

class AddUniqueIndexToCities < ActiveRecord::Migration[6.1]
  def change
    # Remove any existing duplicates first
    execute <<-SQL.squish
      DELETE FROM addresses_cities a
      WHERE a.id NOT IN (
        SELECT MIN(b.id)
        FROM addresses_cities b
        GROUP BY LOWER(b.name), b.state_id
      )
    SQL

    # Add the unique index
    add_index :addresses_cities, 'LOWER(name), state_id', unique: true, name: 'index_addresses_cities_on_lower_name_and_state_id'
  end
end
