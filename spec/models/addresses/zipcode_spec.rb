require 'spec_helper'

RSpec.describe Addresses::Zipcode, type: :model do
  describe 'validation' do
    it { is_expected.to validate_presence_of(:number) }
    it { is_expected.to validate_presence_of(:city_id) }
    it { is_expected.to validate_presence_of(:state_id) }
  end

  describe 'association' do
    it { is_expected.to belong_to(:city) }
    it { is_expected.to belong_to(:neighborhood) }
  end

  describe '#to_s' do
    let!(:zipcode) { create :zipcode }
    it { expect(zipcode.to_s).to eq("Street name, Neighborhood name. City name - State acronym") }
  end
end
