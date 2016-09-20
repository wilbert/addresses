require 'spec_helper'

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
      expect(json["city"]["id"]).to eq(city.id)
      expect(json["city"]["name"]).to eq(city.name)
      expect(json["city"]["state"]["id"]).to eq(state.id)
      expect(json["city"]["state"]["name"]).to eq(state.name)
      expect(json["neighborhood"]["id"]).to eq(neighborhood.id)
      expect(json["neighborhood"]["name"]).to eq(neighborhood.name)
    end
  end
end
