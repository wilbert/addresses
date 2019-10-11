# frozen_string_literal: true

class AddRegionIdToAddressesStates < ActiveRecord::Migration[6.0]
  def change
    add_reference :addresses_states, :region, index: true
  end
end
