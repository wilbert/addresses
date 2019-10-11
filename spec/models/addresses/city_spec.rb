require 'rails_helper'

RSpec.describe Addresses::City, :type => :model do
  describe 'association' do
    it { is_expected.to belong_to(:state) }
    it { is_expected.to have_many(:neighborhoods) }
  end

  describe '#methods' do
    describe '#filter' do
      let!(:state) { create :state }
      let!(:state2) { create :state }
      let!(:city) { create :city, state: state, name: 'Natal' }
      let!(:city2) { create :city, state: state2, name: 'Feliz Natal' }

      it { expect(Addresses::City.filter).to eq([]) }
      it { expect(Addresses::City.filter(name: 'Nat').all).to eq([city]) }
    end
  end
end
