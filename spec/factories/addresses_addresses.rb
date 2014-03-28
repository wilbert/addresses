# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :addresses_address, :class => 'Address' do
    street "MyString"
    number "MyString"
    complement "MyString"
    city nil
    neighborhood nil
    zipcode "MyString"
  end
end
