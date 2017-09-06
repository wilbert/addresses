require 'spec_helper'

module Addresses
    describe StatesController do
        routes { Addresses::Engine.routes }

        before do
            @state = FactoryGirl.create(:addresses_state)
        end

        describe "GET 'index'" do
            it "returns http success" do
                get 'index', { format: :json }
                response.should be_success
            end

            it "assings correct variables" do
                get 'index', { format: :json }
                assigns(:states).should eq([@state])
            end
        end
    end
end
