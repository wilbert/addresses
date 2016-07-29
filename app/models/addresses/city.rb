module Addresses
  class City < ActiveRecord::Base
    belongs_to :state
    has_many :neighborhoods

    # scope :autocomplete, -> { joins(:state) }

    def city_and_state
      "#{name}/#{state_acronym}"
    end

    def state_id
      state.id
    end

    def state_name
      state.name
    end
    
    def state_acronym
      state.acronym
    end
  end
end
