# frozen_string_literal: true

module Addresses
  class State < ActiveRecord::Base
    validates :name, :country_id, presence: true

    belongs_to :country

    has_many :cities
  end
end
