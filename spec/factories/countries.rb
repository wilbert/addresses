# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :country, class: Addresses::Country do
    name "Country name"
    acronym "Country acronym"
  end
end
