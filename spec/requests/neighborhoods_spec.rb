require 'spec_helper'

module Addresses
  describe NeighborhoodsController, type: :controller do
    routes { Addresses::Engine.routes }
    
    before (:each) do
      @state = FactoryGirl.create(:addresses_state)
      @city = FactoryGirl.create(:addresses_city, state: @state)
      @neighborhood = FactoryGirl.create(:addresses_neighborhood, city: @city)
    end

    describe "GET /neighborhoods" do 
      it "should return an interview" do
        get addresses.neighborhoods_path(city_id: @city.id), format: "json"
        json = JSON.parse(response.body)
        json[0]["name"].should == @neighborhood.name
      end
    end
  end
end