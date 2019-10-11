require 'rails_helper'

module Addresses
  RSpec.describe Region, type: :model do
    describe 'association' do
      it { is_expected.to belong_to(:country) }
      it { is_expected.to have_many(:states) }
    end
  end
end
