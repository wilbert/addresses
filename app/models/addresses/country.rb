# frozen_string_literal: true

module Addresses
  class Country < ActiveRecord::Base
    default_scope { order('name asc') }

    has_many :regions
    has_many :states
    has_many :cities, through: :states
    has_many :zipcodes, through: :cities
    has_many :addresses, through: :zipcodes

    validates :name, presence: true
  end
end
