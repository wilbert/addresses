require "spec_helper"

RSpec.describe Addresses::CitiesController, type: :routing do
  routes { Addresses::Engine.routes }

  describe "routing" do
    it "routes to #index" do
      expect(get: "/cities").to route_to("addresses/cities#index")
    end
  end
end
