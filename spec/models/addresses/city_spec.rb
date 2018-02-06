require 'spec_helper'

RSpec.describe Addresses::City, :type => :model do
  describe 'association' do
    it { is_expected.to belong_to(:state) }
    it { is_expected.to have_many(:neighborhoods) }
  end
end
