# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Addresses::Railtie do
  it 'is loaded when the gem is required' do
    expect(defined?(Addresses::Railtie)).to be_truthy
    expect(Addresses::Railtie < Rails::Railtie).to be true
  end

  it 'exposes rake task hooks' do
    expect(Addresses::Railtie).to respond_to(:rake_tasks)
  end
end
