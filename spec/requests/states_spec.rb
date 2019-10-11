# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Addresses::StatesController, type: :request do
  let!(:country) { create :country }
  let!(:state) { create :state, country: country }

  describe "GET /states" do
    before { get '/addresses/states', params: { country_id: country.id, format: "json" } }

    it "should return an list of states" do
      json = JSON.parse(response.body)

      expect(response.status).to be(200)
      expect(json.size).to eq(1)
      expect(json[0]["name"]).to eq(state.name)
    end
  end

  describe "GET /states/:id" do
    before { get "/addresses/states/#{state.id}", params: { format: "json" } }

    it "should return a specific state" do
      json = JSON.parse(response.body)

      expect(response.status).to be(200)
      expect(json["id"]).to eq(state.id)
      expect(json["name"]).to eq(state.name)
    end
  end
end
