# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address, class: Addresses::Address do
    number "Number"
    complement nil
    association :zipcode
  end
end
