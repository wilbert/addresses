require_dependency "addresses/application_controller"

module Addresses
  class StatesController < ApplicationController
    respond_to :json

    def index
        @states = State.order("name asc")
        respond_with @states
    end
  end
end
