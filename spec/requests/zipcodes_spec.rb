require 'rails_helper'

RSpec.describe Addresses::ZipcodesController, type: :request do
  let!(:country) { create :country }
  let!(:state) { create :state, country: country }
  let!(:city) { create :city, state: state }
  let!(:neighborhood) { create :neighborhood, city: city }
  let!(:zipcode) { create :zipcode, city: city, neighborhood: neighborhood, number: '05012010' }

  describe "GET /zipcodes" do
    before do
      self.get '/addresses/zipcodes/05012010?format=json'
    end

    it "should return an interview" do
      json = JSON.parse(response.body)
      expect(response.status).to be(200)
      expect(json["zipcode"]["id"]).to eq(zipcode.id)
      expect(json["zipcode"]["street"]).to eq(zipcode.street)
      expect(json["zipcode"]["neighborhood"]['id']).to eq(neighborhood.id)
      expect(json["zipcode"]["neighborhood"]['name']).to eq(neighborhood.name)
      expect(json["zipcode"]["city"]['id']).to eq(city.id)
      expect(json["zipcode"]["city"]['name']).to eq(city.name)
      expect(json["zipcode"]["state"]['id']).to eq(state.id)
      expect(json["zipcode"]["state"]['name']).to eq(state.name)
      expect(json["zipcode"]["country"]['id']).to eq(country.id)
      expect(json["zipcode"]["country"]['name']).to eq(country.name)
      expect(json["zipcode"]["number"]).to eq('05012010')
    end
  end
end
