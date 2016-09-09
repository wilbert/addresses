require_dependency "addresses/application_controller"

module Addresses
  class CitiesController < ApplicationController
    respond_to :json

    def index
      @state = State.find(params[:state_id])

      @cities = @state.cities.order("name asc")

      respond_with @cities
    end
  end
end
