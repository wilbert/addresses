# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :region, class: Addresses::Region do
    name { 'Nordeste' }
    acronym { 'NE' }
    association :country
  end
end
