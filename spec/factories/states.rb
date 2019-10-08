# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :state, class: Addresses::State do
    name { 'Rio Grande do Norte' }
    acronym { 'RN' }
    association :country
  end
end
