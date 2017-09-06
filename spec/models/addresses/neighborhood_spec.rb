require 'spec_helper'

RSpec.describe Addresses::Neighborhood, :type => :model do
  describe 'association' do
    it { is_expected.to belong_to(:city) }
  end
end
