module Addresses
  class StateSerializer < ActiveModel::Serializer
    attributes :id, :name, :acronym, :country

    belongs_to :country
  end
end
