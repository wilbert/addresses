require 'spec_helper'

RSpec.describe Addresses::ZipcodesController, type: :request do
  let!(:state) { create :state }
  let!(:city) { create :city, state: state }
  let!(:neighborhood) { create :neighborhood, city: city }
  let!(:address) { create :address, city: city, neighborhood: neighborhood, zipcode: '05012010' }

  describe "GET /zipcodes" do
    before { get '/addresses/zipcodes/05012010', params: { format: :json } }

    it "should return an interview" do
      json = JSON.parse(response.body)
      binding.pry
      expect(response.status).to be(200)
      expect(json["id"]).to eq(address.id)
      expect(json["city"]["name"]).to eq(city.name)
      expect(json["city"]["state"]["name"]).to eq(state.name)
      expect(json["neighborhood"]["name"]).to eq(neighborhood.name)
      expect(json["zipcode"]).to eq('05012010')
    end
  end
end
