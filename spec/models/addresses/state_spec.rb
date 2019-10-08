require 'rails_helper'

RSpec.describe Addresses::State, :type => :model do
  describe 'association' do
    it { is_expected.to belong_to(:country) }
    it { is_expected.to have_many(:cities) }
  end
end
