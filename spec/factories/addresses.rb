# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :address, class: Addresses::Address do
    number { '1559' }
    complement 'Sala 66'
    association :zipcode
  end
end
