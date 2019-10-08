# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Addresses::StatesController, type: :controller do
  routes { Addresses::Engine.routes }

  let!(:state) { create :state }

  describe "GET #index" do
    before { get :index, params: { state_id: state.id, format: :json } }

    it { expect(response).to have_http_status(:success) }
    it { expect(assigns(:states)).to eq([state]) }
  end
end
