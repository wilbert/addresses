require "rails_helper"

RSpec.describe Addresses::CitiesController, type: :routing do
  routes { Addresses::Engine.routes }

  describe "routing" do
    it "routes to #index" do
      expect(get: "/cities").to route_to("addresses/cities#index")
    end

    it "routes to #show" do
      expect(get: "/cities/1").to route_to("addresses/cities#show", id: '1')
    end
  end
end
