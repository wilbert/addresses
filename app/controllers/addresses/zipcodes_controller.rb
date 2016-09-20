require_dependency "addresses/application_controller"

module Addresses
  class ZipcodesController < ApplicationController
    def show
      @zipcode = Zipcode.find_or_create_by_service(params[:zipcode])

      render json: @zipcode
    end
  end
end
