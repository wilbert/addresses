require_dependency "addresses/application_controller"

module Addresses
  class NeighborhoodsController < ApplicationController
    def index
      @city = City.find(params[:city_id])

      @neighborhoods = @city.neighborhoods.order("name asc")

      render json: @neighborhoods
    end
  end
end
