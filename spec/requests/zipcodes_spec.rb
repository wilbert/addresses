require 'rails_helper'

RSpec.describe Addresses::ZipcodesController, type: :request do
  let!(:state) { create :state }
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
      expect(json["city_id"]).to eq(city.id)
      expect(json["state_id"]).to eq(state.id)
      expect(json["neighborhood_id"]).to eq(neighborhood.id)
      expect(json["number"]).to eq('05012010')
    end
  end
end
