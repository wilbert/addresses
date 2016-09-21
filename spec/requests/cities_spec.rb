# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Addresses::CitiesController, type: :request do
  let!(:state) { create :state }
  let!(:city) { create :city, state: state }

  describe "GET /cities" do
    before { get '/addresses/cities', params: { state_id: state.id, format: "json" } }

    it "should return an interview" do
      json = JSON.parse(response.body)

      expect(response.status).to be(200)
      expect(json[0]["name"]).to eq(city.name)
    end
  end
end
