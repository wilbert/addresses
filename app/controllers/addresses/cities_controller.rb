require_dependency "addresses/application_controller"

module Addresses
  class CitiesController < ApplicationController
    def index
      @cities = City.filter(params)

      render json: @cities
    end

    def show
      @city = City.find(params[:id])

      render json: @city
    end
  end
end
