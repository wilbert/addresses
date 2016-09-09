# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :address, class: Addresses::Address do
    street "Street name"
    number "Number"
    complement nil
    association :city
    association :neighborhood
    zipcode "Zipcode"
  end
end
