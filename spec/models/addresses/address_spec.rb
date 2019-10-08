require 'rails_helper'

RSpec.describe Addresses::Address, type: :model do
  describe 'validation' do
    it { is_expected.to validate_presence_of(:zipcode_id) }
    it { is_expected.to validate_presence_of(:number) }
  end

  describe 'association' do
    it { is_expected.to belong_to(:zipcode) }
    it { is_expected.to belong_to(:addressable) }
  end

  describe '#to_s' do
    let!(:zipcode) { create(:zipcode, neighborhood: nil) }
    let!(:address) { create(:address) }
    let!(:address1) { create(:address, zipcode: zipcode) }

    it { expect(address.to_s).to eq("Av. Senador Salgado Filho, 1559, Tirol - Natal/RN") }
    it { expect(address1.to_s).to eq("Av. Senador Salgado Filho, 1559 - Natal/RN") }
  end
end
