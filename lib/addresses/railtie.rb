# frozen_string_literal: true

require 'rails/railtie'
require_relative 'task_loader'

module Addresses
  class Railtie < ::Rails::Railtie
    rake_tasks do
      Addresses::TaskLoader.load!
    end
  end
end
