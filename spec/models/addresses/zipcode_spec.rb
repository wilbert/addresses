require 'rails_helper'

RSpec.describe Addresses::Zipcode, type: :model do
  describe 'validation' do
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to validate_presence_of(:city_id) }
    it { is_expected.to validate_presence_of(:state_id) }
    it { is_expected.to validate_presence_of(:street) }
  end

  describe 'association' do
    it { is_expected.to belong_to(:city) }
    it { is_expected.to belong_to(:neighborhood) }
    it { is_expected.to have_many(:addresses) }
  end

  describe '#to_s' do
    let!(:zipcode) { create :zipcode }
    it { expect(zipcode.to_s).to eq("Av. Senador Salgado Filho, Tirol. Natal - RN") }
  end
end
