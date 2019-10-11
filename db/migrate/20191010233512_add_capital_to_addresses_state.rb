# frozen_string_literal: true

class AddCapitalToAddressesState < ActiveRecord::Migration[6.0]
  def change
    add_column :addresses_states, :capital_id, :int, index: true
  end
end
