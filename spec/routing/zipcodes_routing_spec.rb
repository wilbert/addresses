require "rails_helper"

RSpec.describe Addresses::ZipcodesController, type: :routing do
  routes { Addresses::Engine.routes }

  describe "routing" do
    it "routes to #index" do
      expect(get: "/zipcodes/05012010").to route_to("addresses/zipcodes#show", zipcode: '05012010')
    end
  end
end
