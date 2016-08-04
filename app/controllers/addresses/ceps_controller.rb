module Addresses
  class CepsController < ApplicationController

    def show
      @cep_service = CepService.find(params[:id])
      render json: @cep_service.to_json
    end

  end
end