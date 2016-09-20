require "spec_helper"

RSpec.describe Addresses::NeighborhoodsController, type: :routing do
  routes { Addresses::Engine.routes }

  describe "routing" do
    it "routes to #index" do
      expect(get: "/neighborhoods").to route_to("addresses/neighborhoods#index")
    end
  end
end
