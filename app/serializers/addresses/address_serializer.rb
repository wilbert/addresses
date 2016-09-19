module Addresses
  class AddressSerializer < ActiveModel::Serializer
    attributes :id, :street, :number, :complement, :zipcode, :city, :neighborhood

    belongs_to :city
    belongs_to :neighborhood
  end
end
