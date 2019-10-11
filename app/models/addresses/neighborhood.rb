# frozen_string_literal: true

module Addresses
  class Neighborhood < ActiveRecord::Base
    validates :name, :city_id, presence: true

    belongs_to :city

    has_many :zipcodes
  end
end
