module Addresses
    class Address < ActiveRecord::Base
        attr_accessor :state_id
        
        belongs_to :city
        belongs_to :neighborhood
        belongs_to :addressable, polymorphic: true

        validates :zipcode, :number, :city_id, :state_id, presence: true

        after_find :after_find

        def to_s
            "#{self.street}, #{self.number}, #{self.neighborhood}. #{self.city.name} - #{self.city.state.acronym}"
        end

        private
        # => Used to fill state_id
        def after_find
            self.state_id = self.city.state.id unless self.city.nil?
        end
    end
end