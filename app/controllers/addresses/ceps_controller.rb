module Addresses
  class CepsController < ApplicationController
    
    def show
      if defined?(Addresses.with_cep_csrf_token) and Addresses.with_cep_csrf_token
        if !params[:cep_csrf_token].nil? and session[:cep_csrf_token] == params[:cep_csrf_token]
          @cep_service = CepService.find(params[:id])
          render json: @cep_service.to_json and return
        else
          render json:{} and return
        end
      else
        @cep_service = CepService.find(params[:id])
        render json: @cep_service.to_json and return
      end
    end

  end
end