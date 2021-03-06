require 'rails_helper'

RSpec.describe Addresses::NeighborhoodsController, type: :request do
  let!(:state) { create :state }
  let!(:city) { create :city, state: state }
  let!(:neighborhood) { create :neighborhood, city: city }

  describe "GET /neighborhoods" do
    before { get '/addresses/neighborhoods', params: { city_id: city.id, format: "json" } }

    it "should return an interview" do
      json = JSON.parse(response.body)

      expect(response.status).to be(200)
      expect(json[0]["name"]).to eq(neighborhood.name)
    end
  end

  describe "GET /neighborhoods/:id" do
    before { get "/addresses/neighborhoods/#{neighborhood.id}", params: { format: "json" } }

    it "should return a specific neighborhood" do
      json = JSON.parse(response.body)

      expect(response.status).to be(200)
      expect(json["id"]).to eq(neighborhood.id)
      expect(json["name"]).to eq(neighborhood.name)
    end
  end
end
