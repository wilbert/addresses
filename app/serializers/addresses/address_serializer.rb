module Addresses
  class AddressSerializer < ActiveModel::Serializer
    attributes :id, :number, :complement, :zipcode

    belongs_to :zipcode
  end
end
