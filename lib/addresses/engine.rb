require 'rails4-autocomplete'
require 'jquery-ui-rails'
require 'addresses/plugins/form_helper'

begin
  require 'simple_form'
  require 'addresses/plugins/simple_form_plugin'
rescue LoadError
end

module Addresses
  mattr_accessor :with_cep_csrf_token

  class Engine < ::Rails::Engine
    isolate_namespace Addresses

    # initializer "addresses.assets.precompile" do |app|
    #   app.config.assets.precompile += %w(application.js)
    # end

    config.to_prepare do
      ::ApplicationController.helper(Addresses::ApplicationHelper)
    end

    config.generators do |g|
      g.test_framework      :rspec,        :fixture => false
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
      g.assets false
      g.helper false
    end
  end
end
