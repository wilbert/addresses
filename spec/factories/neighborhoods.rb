# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :neighborhood, class: Addresses::Neighborhood do
    name { 'Tirol' }
    association :city
  end
end
