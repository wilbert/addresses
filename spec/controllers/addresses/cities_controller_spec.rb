require 'spec_helper'

module Addresses
    describe CitiesController do
        routes { Addresses::Engine.routes }
        
        before do 
            @state = FactoryGirl.create(:addresses_state)
            @city = FactoryGirl.create(:addresses_city, state: @state)
        end

        describe "GET 'index'" do
            it "returns http success" do
                get 'index', { state_id: @state.id }
                response.should be_success
            end

            it "assings correct variables" do
                get 'index', { state_id: @state.id }
                assigns(:cities).should eq([@city])
            end
        end
    end
end
