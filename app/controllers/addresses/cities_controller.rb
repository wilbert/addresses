require_dependency "addresses/application_controller"

module Addresses
  class CitiesController < ApplicationController
    def index
      @state = State.find(params[:state_id])

      @cities = @state.cities.order("name asc")

      render json: @cities
    end

    def show
      @city = City.find(params[:id])

      render json: @city
    end
  end
end
