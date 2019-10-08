require 'rails_helper'

RSpec.describe Addresses::ZipcodesController, type: :request do
  let!(:country) { create :country }
  let!(:state) { create :state, country: country }
  let!(:city) { create :city, state: state }
  let!(:neighborhood) { create :neighborhood, city: city }
  let!(:zipcode) { create :zipcode, city: city, neighborhood: neighborhood, number: '05012010' }

  describe "GET /zipcodes" do
    before { get '/addresses/zipcodes/05012010', params: { format: :json } }

    it "should return an interview" do
      json = JSON.parse(response.body)
      expect(response.status).to be(200)
      expect(json["id"]).to eq(zipcode.id)
      expect(json["street"]).to eq(zipcode.street)
      expect(json["neighborhood"]['id']).to eq(neighborhood.id)
      expect(json["neighborhood"]['name']).to eq(neighborhood.name)
      expect(json["city"]['id']).to eq(city.id)
      expect(json["city"]['name']).to eq(city.name)
      expect(json["state"]['id']).to eq(state.id)
      expect(json["state"]['name']).to eq(state.name)
      expect(json["country"]['id']).to eq(country.id)
      expect(json["country"]['name']).to eq(country.name)
      expect(json["number"]).to eq('05012010')
    end
  end
end
