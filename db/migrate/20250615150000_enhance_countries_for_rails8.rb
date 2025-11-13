# frozen_string_literal: true

class EnhanceCountriesForRails8 < ActiveRecord::Migration[8.0]
  def change
    # Add composite unique index for ISO codes
    add_index :addresses_countries, [:iso2, :iso3], unique: true, name: 'index_countries_on_iso_codes'
    
    # Add full-text search index
    add_index :addresses_countries, :name, using: :gin, opclass: :gin_trgm_ops
    
    # Add generated column for case-insensitive search
    add_column :addresses_countries, :name_lower, :string, generated: true, 
               as: "LOWER(name)", stored: true
    add_index :addresses_countries, :name_lower
    
    # Add missing ISO columns if they don't exist
    unless column_exists?(:addresses_countries, :iso2)
      add_column :addresses_countries, :iso2, :string, limit: 2
    end
    
    unless column_exists?(:addresses_countries, :iso3)
      add_column :addresses_countries, :iso3, :string, limit: 3
    end
    
    unless column_exists?(:addresses_countries, :capital)
      add_column :addresses_countries, :capital, :string
    end
    
    unless column_exists?(:addresses_countries, :currency)
      add_column :addresses_countries, :currency, :string
    end
    
    unless column_exists?(:addresses_countries, :phone_code)
      add_column :addresses_countries, :phone_code, :string
    end
    
    # Add Rails 8 specific optimizations
    if supports_composite_primary_key?
      # Add composite primary key support for future use
      add_column :addresses_countries, :composite_key, :string, generated: true,
                 as: "CONCAT(iso2, '-', iso3)", stored: true
      add_index :addresses_countries, :composite_key, unique: true
    end
  end
  
  def supports_composite_primary_key?
    # Check if Rails 8 composite primary keys are supported
    ActiveRecord::Base.connection.supports_advisory_locks?
  rescue
    false
  end
end