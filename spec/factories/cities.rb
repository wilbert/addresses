# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :city, class: Addresses::City do
    name { 'Natal' }
    association :state
  end
end
