# frozen_string_literal: true

require_dependency 'addresses/application_controller'

module Addresses
  class RegionsController < ApplicationController
    def index
      @regions = Region.where(country_id: params[:country_id])
      render json: @regions
    end

    def show
      @region = Region.find(params[:id])
      render json: @region
    end
  end
end
