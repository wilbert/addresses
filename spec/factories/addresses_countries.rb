# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :addresses_country, :class => 'Country' do
    name "MyString"
    acronym "MyString"
  end
end
