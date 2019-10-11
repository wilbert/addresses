# frozen_string_literal: true

module Addresses
  class State < ActiveRecord::Base
    belongs_to :country

    default_scope { order('name asc') }

    has_many :cities
    has_many :zipcodes, through: :cities

    validates :name, :country_id, presence: true
  end
end
