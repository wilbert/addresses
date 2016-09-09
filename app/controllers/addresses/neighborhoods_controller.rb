require_dependency "addresses/application_controller"

module Addresses
  class NeighborhoodsController < ApplicationController
    respond_to :json

    def index
      @city = City.find(params[:city_id])

      @neighborhoods = @city.neighborhoods.order("name asc")

      respond_with @neighborhoods
    end
  end
end
