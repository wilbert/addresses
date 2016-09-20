require_dependency "addresses/application_controller"

module Addresses
  class ZipcodesController < ApplicationController
    def show
      @zipcode = Zipcode.find_by(number: params[:zipcode])

      render json: @zipcode
    end
  end
end
