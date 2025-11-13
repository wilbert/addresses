require 'rails_helper'

RSpec.describe Addresses::Country, :type => :model do
  describe 'association' do
    it { is_expected.to have_many(:states) }
  end
  
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:iso2) }
    it { is_expected.to validate_presence_of(:iso3) }
    it { is_expected.to validate_uniqueness_of(:iso2) }
    it { is_expected.to validate_uniqueness_of(:iso3) }
    it { is_expected.to validate_length_of(:iso2).is_equal_to(2) }
    it { is_expected.to validate_length_of(:iso3).is_equal_to(3) }
    it { is_expected.to validate_length_of(:name).is_at_least(2).is_at_most(100) }
  end
  
  describe 'Rails 8 compatibility' do
    it 'supports composite unique indexes' do
      create(:country, iso2: 'US', iso3: 'USA')
      country = build(:country, iso2: 'US', iso3: 'USA')
      expect(country).not_to be_valid
    end
    
    it 'supports case-insensitive search' do
      create(:country, name: 'United States')
      expect(Addresses::Country.where("name_lower = ?", 'united states').count).to eq(1)
    end
  end
end
