module Addresses
  class CitySerializer < ActiveModel::Serializer
    attributes :id, :name, :state

    belongs_to :state
  end
end
