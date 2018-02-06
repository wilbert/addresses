# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Addresses::NeighborhoodsController, type: :controller do
  routes { Addresses::Engine.routes }

  let!(:state) { create :state }
  let!(:city) { create :city, state: state }
  let!(:neighborhood) { create :neighborhood, city: city }

  describe "GET #index" do
    before { get :index, params: { city_id: city.id, format: :json } }

    it { expect(response).to have_http_status(:success) }
    it { expect(assigns(:neighborhoods)).to eq([neighborhood]) }
  end
end
