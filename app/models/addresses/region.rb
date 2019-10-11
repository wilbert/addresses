# frozen_string_literal: true

module Addresses
  class Region < ActiveRecord::Base
    belongs_to :country
    has_many :states
    has_many :cities, through: :states
    has_many :neighborhoods, through: :cities
    has_many :zipcodes, through: :cities
  end
end
