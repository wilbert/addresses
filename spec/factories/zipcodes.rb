FactoryBot.define do
  factory :zipcode, class: Addresses::Zipcode do
    street { 'Av. Senador Salgado Filho' }
    association :city
    association :neighborhood
    number { "59015900" }
  end
end
