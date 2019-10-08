# frozen_string_literal: true

module Addresses
  class Zipcode < ActiveRecord::Base
    attr_accessor :state_id

    belongs_to :city
    belongs_to :neighborhood
    has_many :addresses

    validates :number, :city_id, :state_id, presence: true
    validates :street, presence: true

    before_validation :set_state_id

    delegate :state, to: :city, allow_nil: true
    delegate :country, to: :state, allow_nil: true

    def as_json(options = {})
      super(options.merge(include: [:neighborhood, :city, :state, :country]))
    end

    private
      def set_state_id
        self.state_id = city.try(:state_id)
      end
  end
end
