# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :country, class: Addresses::Country do
    name { 'Brasil' }
    acronym { 'BR' }
  end
end
