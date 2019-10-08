# frozen_string_literal: true

require_dependency 'addresses/application_controller'

module Addresses
  class CitiesController < ApplicationController
    def index
      if State.exists?(params[:state_id])
        @state = State.find(params[:state_id])
        @cities = @state.cities.order('name asc')
      else
        @cities = City.filter(params)
      end

      render json: @cities
    end

    def show
      @city = City.find(params[:id])

      render json: @city
    end
  end
end
