module Addresses
  class NeighborhoodSerializer < ActiveModel::Serializer
    attributes :id, :name, :city

    belongs_to :city
  end
end
