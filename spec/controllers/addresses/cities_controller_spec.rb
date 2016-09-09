# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Addresses::CitiesController, type: :controller do
  routes { Addresses::Engine.routes }

  let!(:state) { create :state }
  let!(:city) { create :city, state: state }

  describe "GET #index" do
    before { get :index, params: { state_id: state.id, format: :json } }

    it { expect(response).to have_http_status(:success) }
    it { expect(assigns(:cities)).to eq([city]) }
  end
end
