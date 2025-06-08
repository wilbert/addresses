# frozen_string_literal: true

require_dependency 'addresses/application_controller'

module Addresses
  class StatesController < ApplicationController
    def index
      @states = State.all
      render json: @states
    end

    def show
      @state = State.find(params[:id])
      render json: @state
    end
  end
end
