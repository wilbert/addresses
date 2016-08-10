require 'spec_helper'

module Addresses
  describe NeighborhoodsController do
    routes { Addresses::Engine.routes }
    
    before do 
      @state = create(:addresses_state)
      @city = create(:addresses_city, state: @state)
      @neighborhood = create(:addresses_neighborhood, city: @city)
    end

    describe "GET 'index'" do
      it "returns http success" do
        get 'index', { city_id: @city.id, format: :json }
        response.should be_success
      end
      it "assings correct variables" do
        get 'index', { city_id: @city.id, format: :json }
        assigns(:neighborhoods).should eq([@neighborhood])
      end
    end
  end
end
