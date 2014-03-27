# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :addresses_city, :class => 'Addresses::City' do
    name "MyString"
    state nil
  end
end
