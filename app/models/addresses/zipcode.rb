module Addresses
  class Zipcode < ActiveRecord::Base
    attr_accessor :state_id

    belongs_to :city
    belongs_to :neighborhood
    has_many :addresses

    validates :number, :city_id, :state_id, :street, presence: true

    after_find :set_state_id
    before_validation :set_state_id

    def self.find_or_create_by_service(number)
      zipcode = Zipcode.find_by(number: number)

      unless zipcode.present?
        remote_zipcode = ZipcodeService.find(number)
        if remote_zipcode.present?
          new_zipcode = Zipcode.new
          new_zipcode.street = [remote_zipcode[:tipo_logradouro],remote_zipcode[:logradouro]].join(' ')
          new_zipcode.number = number

          remote_state = State.find_or_create_by(acronym: remote_zipcode[:uf].upcase)
          remote_city = City.find_or_create_by(name: remote_zipcode[:cidade], state_id: remote_state.id)

          new_zipcode.city = remote_city
          new_zipcode.neighborhood = Neighborhood.find_or_create_by(name: remote_zipcode[:bairro], city_id: remote_city.id)

          new_zipcode.save!

          return new_zipcode
        end
      end

      zipcode
    rescue
      nil
    end

    def to_s
      "#{self.street}, #{self.neighborhood.name}. #{self.city.name} - #{self.city.state.acronym}"
    end

    def as_json options=nil
      options ||= {}
      options[:methods] = ((options[:methods] || []) + [:state_id])
      super options
    end

    private
    def set_state_id
      self.state_id = self.city.state.id unless self.city.nil?
    end
  end
end
