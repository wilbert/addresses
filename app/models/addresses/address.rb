module Addresses
  class Address < ActiveRecord::Base
    belongs_to :zipcode
    belongs_to :addressable, polymorphic: true

    validates :number, presence: true
    validates :zipcode_id, presence: true, if: Proc.new{|a| a.try(:zipcode).try(:street).blank? }
    delegate :street, :neighborhood, :city, to: :zipcode

    accepts_nested_attributes_for :zipcode, allow_destroy: false

    def to_s
      to_s = "#{street}, #{number}"
      to_s += ", #{neighborhood.name}" if neighborhood
      to_s += " - #{city.name}" if city
      to_s += "/#{city.state.acronym}" if city && city.state
    end
  end
end
