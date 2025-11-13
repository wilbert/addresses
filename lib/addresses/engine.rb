# frozen_string_literal: true

require 'rails/engine'
require_relative 'task_loader'

module Addresses
  class Engine < ::Rails::Engine
    isolate_namespace Addresses

    config.generators do |g|
      g.test_framework :rspec
      g.factory_bot dir: 'spec/factories'
      g.assets false
      g.helper false
    end

    rake_tasks do
      Addresses::TaskLoader.load!
    end
  end
end
