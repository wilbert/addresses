require "spec_helper"

describe Addresses::CitiesController do
    routes { Addresses::Engine.routes }
    describe "routing" do
        it "routes to #index" do
            get("/cities").should route_to("addresses/cities#index")
        end
    end
end
