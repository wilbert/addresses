module Addresses
  class Address < ActiveRecord::Base
    belongs_to :city
    belongs_to :neighborhood
    belongs_to :addressable, polymorphic: true
  end
end
