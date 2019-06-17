module Addresses
  class Neighborhood < ActiveRecord::Base
    validates :name, :city_id, presence: true

    belongs_to :city
  end
end
