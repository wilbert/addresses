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
    validates :iso2, presence: true, uniqueness: true, length: { is: 2 }
    validates :iso3, presence: true, uniqueness: true, length: { is: 3 }
    validates :name, length: { in: 2..100 }
  end
end
