require 'spec_helper'

RSpec.describe Addresses::Address, type: :model do
  describe 'validation' do
    it { is_expected.to validate_presence_of(:zipcode) }
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to validate_presence_of(:city_id) }
    it { is_expected.to validate_presence_of(:state_id) }
  end

  describe 'association' do
    it { is_expected.to belong_to(:city) }
    it { is_expected.to belong_to(:neighborhood) }
    it { is_expected.to belong_to(:addressable) }
  end

  describe '#to_s' do
    let!(:address) { create :address }
    it { expect(address.to_s).to eq("Street name, Number, Neighborhood name. City name - State acronym") }
  end
end
