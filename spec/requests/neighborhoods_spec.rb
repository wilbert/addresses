require 'spec_helper'

RSpec.describe Addresses::NeighborhoodsController, type: :request do
  let!(:state) { create :state }
  let!(:city) { create :city, state: state }
  let!(:neighborhood) { create :neighborhood, city: city }

  describe "GET /neighborhoods" do
    before { get '/addresses/neighborhoods', params: { city_id: city.id, format: "json" } }

    it "should return an interview" do
      json = JSON.parse(response.body)

      expect(response.status).to be(200)
      expect(json[0]["id"]).to eq(neighborhood.id)
      expect(json[0]["name"]).to eq(neighborhood.name)
      expect(json[0]["city"]["id"]).to eq(city.id)
      expect(json[0]["city"]["name"]).to eq(city.name)
    end
  end
end
