module Addresses
  class City < ActiveRecord::Base
    belongs_to :state

    has_many :neighborhoods
  end
end
