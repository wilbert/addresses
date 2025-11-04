# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Addresses::CitiesController, type: :request do
  let!(:state) { create :state }
  let!(:city) { create :city, state: state }

  describe "GET /cities" do
    before do
      self.get '/addresses/cities?state_id=' + state.id.to_s + '&format=json'
    end

    it "should return an list of cities" do
      json = JSON.parse(response.body)

      expect(response.status).to be(200)
      expect(json.size).to eq(1)
      expect(json[0]["name"]).to eq(city.name)
    end
  end

  describe "GET /cities/:id" do
    before do
      self.get "/addresses/cities/#{city.id}?format=json"
    end

    it "should return a specific city" do
      json = JSON.parse(response.body)

      expect(response.status).to be(200)
      expect(json["id"]).to eq(city.id)
      expect(json["name"]).to eq(city.name)
    end
  end
end
