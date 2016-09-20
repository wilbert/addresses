# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Addresses::ZipcodesController, type: :controller do
  routes { Addresses::Engine.routes }

  let!(:state) { create :state }
  let!(:city) { create :city, state: state }
  let!(:neighborhood) { create :neighborhood, city: city }
  let!(:zipcode) { create :zipcode, city: city, neighborhood: neighborhood, number: '05012010' }

  describe "GET #show" do
    before { get :show, params: { zipcode: '05012010', format: :json } }

    it { expect(response).to have_http_status(:success) }
    it { expect(assigns(:zipcode)).to eq(zipcode) }
  end
end
