# frozen_string_literal: true
require 'spec_helper'

RSpec.describe Addresses::CitiesController, type: :controller do
  routes { Addresses::Engine.routes }

  let!(:state) { create :state }
  let!(:state2) { create :state }
  let!(:city) { create :city, state: state, name: 'Natal' }
  let!(:city2) { create :city, state: state2, name: 'São Paulo' }

  describe "GET #index" do
    before { get :index, params: { state_id: state.id, format: :json } }

    it { expect(response).to have_http_status(:success) }
    it { expect(assigns(:cities)).to eq([city]) }
  end

  describe "GET #index without state id" do
    before { get :index, params: { format: :json } }

    it { expect(response).to have_http_status(:success) }
    it { expect(assigns(:cities)).to eq([]) }
  end

  describe "GET #index with search by name" do
    before { get :index, params: { name: 'natal', format: :json } }

    it { expect(response).to have_http_status(:success) }
    it { expect(assigns(:cities)).to eq([city]) }
  end

  describe "GET #show" do
    before { get :show, params: { id: city.id, format: :json } }

    it { expect(response).to have_http_status(:success) }
    it { expect(assigns(:city)).to eq(city) }
  end
end
