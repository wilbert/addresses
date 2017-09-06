# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :city, class: Addresses::City do
    name "City name"
    association :state
  end
end
