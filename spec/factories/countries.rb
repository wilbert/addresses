# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :country, class: Addresses::Country do
    name { 'Brazil' }
    iso2 { 'BR' }
    iso3 { 'BRA' }
    capital { 'Brasília' }
    currency { 'BRL' }
    phone_code { '+55' }
  end
end
