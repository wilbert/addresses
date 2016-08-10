module Addresses
  class NeighborhoodsController < ApplicationController
    def index
      @city = City.find(params[:city_id])
      
      @neighborhoods = @city.neighborhoods.order("name asc")

      respond_with @neighborhoods
    end
  end
end
