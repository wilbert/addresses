# Addresses

A robust Ruby on Rails engine for managing international and Brazilian addresses, including countries, states, cities, neighborhoods, and zipcodes. MIT Licensed.

## Features
- Country, State, City, Neighborhood, and Address models
- Official data for all countries, Brazilian states, and cities (IBGE)
- Easy integration with Rails 4, 5, 6, and 7
- Rake tasks for fast population of address data

## Installation

### Rails 7
- Requires Ruby >= 2.7
- Add to your Gemfile:
  ```ruby
  gem 'addresses', '~> 3.0'
  ```

### Rails 6
- Requires Ruby >= 2.3
- Add to your Gemfile:
  ```ruby
  gem 'addresses', '~> 2.0'
  ```

### Rails 5
- Requires Ruby >= 2.2
- Add to your Gemfile:
  ```ruby
  gem 'addresses', '~> 1.0.0'
  ```

### Rails <= 4
- Add to your Gemfile:
  ```ruby
  gem 'addresses', '0.0.9'
  ```

### Engine Mounting
Add to your `routes.rb`:
```ruby
mount Addresses::Engine => "/addresses"
```

### Database Setup
Copy and run migrations:
```sh
rake addresses:install:migrations
rake db:migrate
```

## Usage

### Populating Data
Populate tables with official data:
```sh
bundle exec rake br:addresses         # Popula países, estados, cidades, bairros e endereços do Brasil
bundle exec rake populate:countries   # Popula todos os países do mundo (nomes em pt-br)
bundle exec rake br:states            # Popula todos os estados do Brasil
bundle exec rake br:cities            # Popula todas as cidades do Brasil a partir do CSV oficial do IBGE
bundle exec rake br:neighborhoods     # Popula todos os bairros do Brasil
bundle exec rake populate:br:zipcodes          # Popula todos os CEPs do Brasil a partir do CSV oficial
```

See other tasks in `lib/tasks/populate/` for more options.

### Example: Querying Cities
```ruby
Addresses::City.where(state_id: 26).pluck(:name)
```

## API Endpoints

The Addresses engine exposes RESTful endpoints for states, cities, neighborhoods, and zipcodes. Mounting the engine at `/addresses` (as shown above) will provide the following endpoints:

### States
- `GET /addresses/states` — List all states
- `GET /addresses/states/:id` — Show a specific state

### Cities
- `GET /addresses/cities` — List all cities
- `GET /addresses/cities/:id` — Show a specific city

### Neighborhoods
- `GET /addresses/neighborhoods` — List all neighborhoods
- `GET /addresses/neighborhoods/:id` — Show a specific neighborhood

### Zipcodes
- `GET /addresses/zipcodes` — List all zipcodes
- `GET /addresses/zipcodes/:id` — Show a specific zipcode

#### Example: Fetch all cities in a state
```sh
curl \
  -X GET \
  "http://localhost:3000/addresses/cities?state_id=26"
```

> Replace `localhost:3000` with your host and port as needed.

## JavaScript Integration: Dynamic Address Form (Stimulus)

To enable dynamic selection of states, cities, and neighborhoods, and auto-fill by zipcode, use the provided Stimulus controller:

1. **Install Stimulus** (if not already):
   ```sh
   bin/importmap pin @hotwired/stimulus
   ```
   Or, if using Webpacker:
   ```sh
   yarn add @hotwired/stimulus
   ```

2. **Add the controller** to your application:
   - Copy `app/controllers/addresses/address_form_controller.js` from this gem into your app's JavaScript controllers folder (or import it if using as an engine).
   - Register the controller in your Stimulus setup (e.g., `application.register('address-form', AddressFormController)`).

3. **Example HTML usage:**
   ```erb
   <form data-controller="address-form">
     <input data-address-form-target="zipcode" data-action="input->address-form#onZipcodeInput" placeholder="CEP" />

     <select data-address-form-target="state" data-action="change->address-form#onStateChange">
       <% @states.each do |state| %>
         <option value="<%= state.id %>"><%= state.name %></option>
       <% end %>
     </select>

     <select data-address-form-target="city" data-action="change->address-form#onCityChange">
       <!-- Cities will be dynamically loaded -->
     </select>

     <select data-address-form-target="neighborhood">
       <!-- Neighborhoods will be dynamically loaded -->
     </select>
   </form>
   ```

4. **How it works:**
   - Typing a valid zipcode auto-fills state, city, and neighborhood if found.
   - Changing the state reloads the cities.
   - Changing the city reloads the neighborhoods.

5. **API endpoints required:**
   - `/addresses/zipcodes/:zipcode.json`
   - `/addresses/cities.json?state_id=STATE_ID`
   - `/addresses/neighborhoods.json?city_id=CITY_ID`

> Make sure your Rails app exposes these endpoints and that CORS is configured if using across domains.

## Testing

This project uses RSpec. To run the test suite:
```sh
bundle install
bundle exec rspec
```

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b my-feature`)
3. Commit your changes (`git commit -am 'Add new feature'`)
4. Push to the branch (`git push origin my-feature`)
5. Create a new Pull Request

Please include tests for new features and follow the existing code style.

## Versioning
- Rails 7: `~> 3.0`
- Rails 6: `~> 2.0`
- Rails 5: `~> 1.0.0`
- Rails <= 4: `0.0.9`

## Best Practices
- Always run migrations after updating the gem
- Use the provided rake tasks to ensure official and up-to-date data
- For custom data, extend the models and tasks as needed
- Keep your gem version in sync with your Rails version

## License
MIT License. See [MIT-LICENSE](MIT-LICENSE) for details.

---
For more information, see the code in `lib/tasks/populate/` and the model documentation.
