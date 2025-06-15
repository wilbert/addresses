# frozen_string_literal: true

class AddUnaccentedNameToNeighborhoods < ActiveRecord::Migration[6.1]
  def up
    # Add the unaccented_name column
    add_column :addresses_neighborhoods, :unaccented_name, :string
    
    # Add index on unaccented_name and city_id for faster lookups
    add_index :addresses_neighborhoods, [:unaccented_name, :city_id], 
              name: 'index_addresses_neighborhoods_on_unaccented_name_and_city_id'
    
    # Update existing records to set unaccented_name
    execute <<-SQL.squish
      UPDATE addresses_neighborhoods 
      SET unaccented_name = LOWER(UNACCENT(name))
    SQL
    
    # Make the column not null after populating
    change_column_null :addresses_neighborhoods, :unaccented_name, false
  end
  
  def down
    remove_index :addresses_neighborhoods, name: 'index_addresses_neighborhoods_on_unaccented_name_and_city_id'
    remove_column :addresses_neighborhoods, :unaccented_name
  end
end
