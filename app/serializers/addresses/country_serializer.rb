module Addresses
  class CountrySerializer < ActiveModel::Serializer
    attributes :id, :name, :acronym
  end
end
