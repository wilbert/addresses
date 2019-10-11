# frozen_string_literal: true

module Addresses
  class Region < ActiveRecord::Base
    belongs_to :country

    default_scope { order('name asc') }

    has_many :states
    has_many :cities, through: :states
    has_many :neighborhoods, through: :cities
    has_many :zipcodes, through: :cities

    validates :name, :country_id, presence: true
  end
end
