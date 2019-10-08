# frozen_string_literal: true

require_dependency 'addresses/application_controller'

module Addresses
  class ZipcodesController < ApplicationController
    def show
      @zipcode = Zipcode.find_by(number: params[:zipcode])

      if @zipcode.present?
        render json: @zipcode
      else
        render json: { errors: :zipcode_not_found }, success: false, status: :unprocessable_entity
      end
    end
  end
end
