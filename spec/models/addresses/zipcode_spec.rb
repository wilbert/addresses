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
    it { is_expected.to have_many(:addresses) }
  end

  describe '.find_or_create_by_service', :vcr do
    context 'when the zipcode exists in database' do
      let!(:zipcode) { create :zipcode }
      let!(:searched_zipcode) { Addresses::Zipcode.find_or_create_by_service(zipcode.number) }

      it { expect(searched_zipcode).to eq(zipcode) }
    end

    context 'when the zipcode not exists in database' do
      context 'but the zipcode was found in web service' do
        let!(:searched_zipcode) { Addresses::Zipcode.find_or_create_by_service('05012010') }

        it { expect(searched_zipcode).to be_a_instance_of(Addresses::Zipcode) }
        it { expect(searched_zipcode.number).to eq('05012010') }
        it { expect(searched_zipcode.street).to eq('Rua Ministro Gastão Mesquita') }
      end

      context 'and the zipcode was not found in web service' do
        let!(:searched_zipcode) { Addresses::Zipcode.find_or_create_by_service('99999999') }
        it { expect(searched_zipcode).to be_nil }
      end
    end
  end

  describe '#to_s' do
    let!(:zipcode) { create :zipcode }
    it { expect(zipcode.to_s).to eq("Street name, Neighborhood name. City name - State acronym") }
  end
end
