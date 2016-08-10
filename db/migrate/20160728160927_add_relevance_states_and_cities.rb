class AddRelevanceStatesAndCities < ActiveRecord::Migration
  def change
    add_column :addresses_states, :relevance, :integer, default:0
    add_column :addresses_cities, :relevance, :integer, default:0
  end
end
