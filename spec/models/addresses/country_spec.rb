require 'rails_helper'

RSpec.describe Addresses::Country, :type => :model do
  describe 'association' do
    it { is_expected.to have_many(:states) }
  end
end
