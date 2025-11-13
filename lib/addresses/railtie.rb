# frozen_string_literal: true

require 'rails/railtie'

module Addresses
  class Railtie < ::Rails::Railtie
    rake_tasks do
      Dir[File.join(__dir__, 'tasks/**/*.rake')].each { |task| load task }
    end
  end
end
