= Addresses

This project rocks and uses MIT-LICENSE.

It allows you use these models:

* Country
* State (belongs to country)
* City (belongs to State)
* Neighborhood (belongs to city)
* Address (Belongs to Neighborhood and City, because neighborhood is not required)

== Installation

=== Rails 5

This version requires Ruby >= 2.2 for older ruby versions add to your Gemfile "gem 'addresses', '0.0.9'".

Add this code to your Gemfile:

    gem 'addresses', '~> 1.0.0'

=== Rails <= 4

Add this code to your Gemfile:

    gem 'addresses', '0.0.9'

After this, add this line to your routes:

    mount Addresses::Engine => "/addresses"

Copy migrations to your project and execute than to create tables in your database:

    rake addresses:install:migrations
    rake db:migrate

If you want populate Contries, States (Brazilian only), Cities (Brazilian only) and Neighborhoods (Brazilian only) use this command:

    rake addresses

Now you can test in console if everything are working:

    Addresses::Contry.count

Use these models in your project as:

    address = Addresses::Address.new
    address.street = "Street name"
    address.number = "Number"
    address.complement = "Complement of address"
    address.zipcode = "zipcode"
    address.city = Address::City.find(city_id)
    address.neighborhood = Address::Neighborhood.find(neighborhood_id)
    address.save
