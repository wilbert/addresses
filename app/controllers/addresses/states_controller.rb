module Addresses
  class StatesController < ApplicationController

    def index
      @states = Country.find(country_default_id).states.order(:relevance, :name)
      respond_with @states
    end

    private
    def country_default_id
      33
    end
  end
end
