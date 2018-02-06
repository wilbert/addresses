# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :state, class: Addresses::State do
    name "State name"
    acronym "State acronym"
    association :country
  end
end
