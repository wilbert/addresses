# frozen_string_literal: true

module Addresses
  module TaskLoader
    module_function

    def load!
      return if @tasks_loaded

      Dir[File.join(__dir__, 'tasks/**/*.rake')].each { |file| load file }
      @tasks_loaded = true
    end
  end
end
