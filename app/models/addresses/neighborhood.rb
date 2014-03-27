module Addresses
  class Neighborhood < ActiveRecord::Base
    belongs_to :city
  end
end
