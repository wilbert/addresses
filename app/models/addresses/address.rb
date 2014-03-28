module Addresses
    class Address < ActiveRecord::Base
        attr_accessor :state_id
        
        belongs_to :city
        belongs_to :neighborhood
        belongs_to :addressable, polymorphic: true

        validates :zipcode, :number, :city_id, :state_id, presence: true

        def to_s
            "#{self.street}, #{self.number}, #{self.neighborhood}. #{self.city.name} - #{self.city.state.abbreviation}"
        end
    end
end