require_dependency "addresses/application_controller"

module Addresses
  class StatesController < ApplicationController
    def index
      @states = State.order("name asc")
      render json: @states
    end
  end
end
