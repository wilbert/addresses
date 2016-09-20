class RemoveZipcodeAttributesFromAddresses < ActiveRecord::Migration[5.0]
  def change
    remove_column :addresses_addresses, :street, :string
    remove_reference :addresses_addresses, :city, index: true
    remove_reference :addresses_addresses, :neighborhood, index: true
    remove_column :addresses_addresses, :zipcode, :string

    add_reference :addresses_addresses, :zipcode, index: true
  end
end
