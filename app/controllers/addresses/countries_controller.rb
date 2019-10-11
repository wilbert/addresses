# frozen_string_literal: true

require_dependency 'addresses/application_controller'

module Addresses
  class CountriesController < ApplicationController
    def index
      @countries = Country.all
      render json: @countries
    end

    def show
      @city = Country.find(params[:id])
      render json: @city
    end
  end
end
