require 'spec_helper'

module Addresses
  describe CitiesController, type: :controller do
    routes { Addresses::Engine.routes }
    
    before do 
      @state = create(:addresses_state)
      @city = create(:addresses_city, state: @state)
    end

    describe "GET 'index'" do
      it "returns http success" do
        get 'index', { state_id: @state.id, format: :json }
        response.should be_success
      end
      it "assings correct variables" do
        get 'index', { state_id: @state.id, format: :json }
        assigns(:cities).should eq([@city])
      end
    end
  end
end
