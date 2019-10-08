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
      let!(:city2) { create :city, state: state2, name: 'São Paulo' }

      it { expect(Addresses::City.filter.all).to eq([city, city2]) }
      it { expect(Addresses::City.filter(name: 'paulo').all).to eq([city2]) }
    end
  end
end
