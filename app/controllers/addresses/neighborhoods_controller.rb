# frozen_string_literal: true

require_dependency 'addresses/application_controller'

module Addresses
  class NeighborhoodsController < ApplicationController
    def index
      @neighborhoods = Neighborhood.where(city_id: params[:city_id])
      render json: @neighborhoods
    end

    def show
      @neighborhood = Neighborhood.find(params[:id])
      render json: @neighborhood
    end
  end
end
