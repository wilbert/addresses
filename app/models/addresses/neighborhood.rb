# frozen_string_literal: true

module Addresses
  class Neighborhood < ActiveRecord::Base
    belongs_to :city

    default_scope { order('name asc') }

    has_many :zipcodes

    validates :name, :city_id, presence: true
  end
end
