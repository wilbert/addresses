module Addresses
  class CitiesController < ApplicationController
    respond_to :html
    autocomplete :city, :name, display_value: :label_autocomplete_for_city, full_model:true, class_name:'Addresses::City', case_sensitive:true, extra_data:['state_id', 'state_name', 'name'] 

    def index
      @state = State.find(params[:state_id])
      @cities = @state.cities.order(:relevance, :name)
      respond_with @cities
    end
  end
end
