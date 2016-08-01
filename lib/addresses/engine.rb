# require 'rails-jquery-autocomplete'
require 'rails4-autocomplete'
require 'jquery-ui-rails'

module Addresses
  class Engine < ::Rails::Engine
    isolate_namespace Addresses

    # initializer "addresses.assets.precompile" do |app|
    #   app.config.assets.precompile += %w(application.js)
    # end    

    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end
  end
end
