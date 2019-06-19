# encoding: utf-8

namespace :br do
  desc 'Addresses rake'
  task addresses: [:environment] do
    Rake::Task["populate:countries"].invoke
  end
end
