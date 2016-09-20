FactoryGirl.define do
  factory :zipcode, class: Addresses::Zipcode do
    street "Street name"
    association :city
    association :neighborhood
    number "12345678"
  end
end
