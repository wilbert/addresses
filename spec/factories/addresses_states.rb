# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :addresses_state, :class => 'Addresses::State' do
    name "MyString"
    acronym "MyString"
    country nil
  end
end
