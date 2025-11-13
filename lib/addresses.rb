# frozen_string_literal: true

module Addresses
end

require_relative '../app/models/addresses/country'
require_relative '../app/services/addresses/country_data_service'
require_relative 'addresses/country_seed_data'

require 'addresses/engine' if defined?(::Rails::Engine)
require 'addresses/railtie' if defined?(Rails)
