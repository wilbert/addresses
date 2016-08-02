require 'spec_helper'

describe Addresses::CitiesController do
  #routes { Addresses::Engine.routes }
  
  before (:each) do
    @state = FactoryGirl.create(:addresses_state)
    @city = FactoryGirl.create(:addresses_city, state: @state)
  end

  describe "GET /cities" do 
    it "should return an interview" do
      get addresses.cities_path(state_id: @state.id), format: "json"
      json = JSON.parse(response.body)
      json[0]["name"].should == @city.name
    end
  end
end                         