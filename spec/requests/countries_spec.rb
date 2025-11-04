# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Addresses::CountriesController, type: :request do
  let!(:country) { create :country }
  let!(:country2) { create :country }

  describe "GET /countries" do
    before do
      self.get '/addresses/countries?format=json'
    end

    it "should return an list of countries" do
      json = JSON.parse(response.body)

      expect(response.status).to be(200)
      expect(json.size).to eq(2)
      expect(json[0]["name"]).to eq(country.name)
    end
  end

  describe "GET /countries/:id" do
    before do
      self.get "/addresses/countries/#{country.id}?format=json"
    end

    it "should return a specific country" do
      json = JSON.parse(response.body)

      expect(response.status).to be(200)
      expect(json["id"]).to eq(country.id)
      expect(json["name"]).to eq(country.name)
    end
  end
end
