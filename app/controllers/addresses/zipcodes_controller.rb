require_dependency "addresses/application_controller"

module Addresses
  class ZipcodesController < ApplicationController
    def show
      @zipcode = Zipcode.find_or_create_by_service(params[:zipcode])

      if @zipcode.nil?
        render json: { errors: ['Zipcode not found'] }, success: false, status: :unprocessable_entity
      else
        render json: @zipcode
      end
    end
  end
end
