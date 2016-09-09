# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :neighborhood, class: Addresses::Neighborhood do
    name "Neighborhood name"
    association :city
  end
end
