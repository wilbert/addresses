module Addresses
  class ZipcodeSerializer < ActiveModel::Serializer
    attributes :id, :street, :number, :city, :neighborhood

    belongs_to :city
    belongs_to :neighborhood
  end
end
