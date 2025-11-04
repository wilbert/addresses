# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Addresses::RegionsController, type: :request do
  let!(:country) { create :country }
  let!(:region) { create :region, country: country }

  describe "GET /regions" do
    before do
      self.get '/addresses/regions?country_id=' + country.id.to_s + '&format=json'
    end

    it "should return an list of regions" do
      json = JSON.parse(response.body)

      expect(response.status).to be(200)
      expect(json.size).to eq(1)
      expect(json[0]["name"]).to eq(region.name)
    end
  end

  describe "GET /regions/:id" do
    before do
      self.get "/addresses/regions/#{region.id}?format=json"
    end

    it "should return a specific region" do
      json = JSON.parse(response.body)

      expect(response.status).to be(200)
      expect(json["id"]).to eq(region.id)
      expect(json["name"]).to eq(region.name)
    end
  end
end
