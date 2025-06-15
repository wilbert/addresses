# encoding: utf-8
# frozen_string_literal: true

namespace :br do
  desc 'Addresses rake'
  task addresses: [:environment] do
    Rake::Task['populate:countries'].invoke
  end
end

namespace :addresses do
  desc 'Clean all address models'
  task clean: :environment do
    puts 'Cleaning addresses models'
    Addresses::Address.delete_all
    Addresses::Zipcode.delete_all
    Addresses::Neighborhood.delete_all
    Addresses::City.delete_all
    Addresses::Region.delete_all
    Addresses::State.delete_all
    Addresses::Country.delete_all
  end
end
