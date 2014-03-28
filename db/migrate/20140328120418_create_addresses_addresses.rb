class CreateAddressesAddresses < ActiveRecord::Migration
  def change
    create_table :addresses_addresses do |t|
      t.string :street
      t.string :number
      t.string :complement
      t.references :city, index: true
      t.references :neighborhood, index: true
      t.string :zipcode
      t.integer :addressable_id, index: true
      t.string :addressable_type

      t.timestamps
    end
  end
end
