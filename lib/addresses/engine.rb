module Addresses
  class Engine < ::Rails::Engine
    isolate_namespace Addresses

    config.generators do |g|
      g.test_framework :rspec
      g.factory_bot dir: 'spec/factories'
      g.assets false
      g.helper false
    end
  end
end
