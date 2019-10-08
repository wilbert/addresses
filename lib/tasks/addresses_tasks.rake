# encoding: utf-8
# frozen_string_literal: true

namespace :br do
  desc 'Addresses rake'
  task addresses: [:environment] do
    Rake::Task['populate:countries'].invoke
  end
end
