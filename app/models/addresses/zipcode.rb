module Addresses
  class Zipcode < ActiveRecord::Base
    attr_accessor :state_id

    belongs_to :city
    belongs_to :neighborhood
    has_many :addresses

    validates :number, :city_id, :state_id, presence: true

    after_find :set_state_id
    before_validation :set_state_id

    def to_s
      "#{self.street}, #{self.neighborhood.name}. #{self.city.name} - #{self.city.state.acronym}"
    end

    private
    def set_state_id
      self.state_id = self.city.state.id unless self.city.nil?
    end
  end
end
