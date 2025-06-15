class EnableUnaccentExtension < ActiveRecord::Migration[6.1]
  def up
    # Check if extension exists and is not already enabled
    execute "CREATE EXTENSION IF NOT EXISTS unaccent"
  end

  def down
    execute "DROP EXTENSION IF EXISTS unaccent"
  end
end
