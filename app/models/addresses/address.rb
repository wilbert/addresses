module Addresses
  class Address < ActiveRecord::Base
    belongs_to :zipcode
    belongs_to :addressable, polymorphic: true

    validates :zipcode_id, :number, presence: true
    delegate :street, :neighborhood, :city, to: :zipcode

    accepts_nested_attributes_for :zipcode, allow_destroy: false

    def to_s
      "#{self.street}, #{self.number}, #{self.neighborhood.name}. #{self.city.name} - #{self.city.state.acronym}"
    end
  end
end
