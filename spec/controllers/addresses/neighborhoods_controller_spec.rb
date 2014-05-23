require 'spec_helper'

module Addresses
    describe NeighborhoodsController do
        routes { Addresses::Engine.routes }
        
        before do 
            @state = FactoryGirl.create(:addresses_state)
            @city = FactoryGirl.create(:addresses_city, state: @state)
            @neighborhood = FactoryGirl.create(:addresses_neighborhood, city: @city)
        end

        describe "GET 'index'" do
            it "returns http success" do
                get 'index', { city_id: @state.id, format: :json }

                response.should be_success
            end

            it "assings correct variables" do
                get 'index', { city_id: @state.id, format: :json }
                assigns(:neighborhoods).should eq([@neighborhood])
            end
        end
    end
end
