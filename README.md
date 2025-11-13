# Addresses

A robust Ruby on Rails engine for managing international and Brazilian addresses, including countries, states, cities, neighborhoods, and zipcodes. MIT Licensed.

## Features
- Country, State, City, Neighborhood, and Address models
- Official data for all countries, Brazilian states, and cities (IBGE)
- Easy integration with Rails 4, 5, 6, and 7
- Rake tasks for fast population of address data

## Installation

### Rails 8
- Requires Ruby >= 3.0
- Add to your Gemfile:
  ```ruby
  gem 'addresses', '~> 4.0'
  ```

### Rails 7
- Requires Ruby >= 2.7
- Add to your Gemfile:
  ```ruby
  gem 'addresses', '~> 3.0', '< 4.0'
  ```

### Rails 6
- Requires Ruby >= 2.3
- Add to your Gemfile:
  ```ruby
  gem 'addresses', '~> 2.0', '< 3.0'
  ```

### Rails 5
- Requires Ruby >= 2.2
- Add to your Gemfile:
  ```ruby
  gem 'addresses', '~> 1.0.0', '< 2.0'
  ```

### Rails <= 4
- Add to your Gemfile:
  ```ruby
  gem 'addresses', '0.0.9', '< 1.0'
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

## Rake Tasks

### Database Population
Populate tables with official data:

```sh
# Rails 8 Countries Creation (NEW)
bundle exec rake addresses:countries:create              # Create countries from predefined ISO data
bundle exec rake addresses:countries:create --verbose   # Show detailed progress
bundle exec rake addresses:countries:create --dry-run     # Preview without making changes
bundle exec rake addresses:countries:create --limit=5     # Process only first 5 countries

# Main population tasks
bundle exec rake addresses:br:all            # Populates countries, states, cities, neighborhoods, and addresses for Brazil
bundle exec rake addresses:countries:populate # Populates all countries in the world (names in pt-br)
bundle exec rake addresses:br:states          # Populates all Brazilian states
bundle exec rake addresses:br:cities          # Populates all Brazilian cities from official IBGE CSV
bundle exec rake addresses:br:neighborhoods   # Populates all Brazilian neighborhoods
bundle exec rake addresses:br:zipcodes        # Populates all Brazilian zipcodes from official CSV

# Database maintenance
bundle exec rake addresses:clean              # Cleans all address-related data (use with caution!)
```

### Additional Tasks
```sh
# Extract neighborhoods from CEP data
bundle exec rake addresses:br:neighborhoods:extract  # Extract unique neighborhoods to CSV
```

### Rails 8 Countries Creation Task
The new `addresses:countries:create` task provides automated country data creation with the following features:

- **Automatic creation** of countries with ISO 3166-1 alpha-2 and alpha-3 codes
- **Transaction-based processing** for data integrity
- **Duplicate detection** and graceful handling
- **Progress feedback** and error reporting
- **Support for custom attributes** (capital, currency, phone code)
- **Rails 8 optimized** with composite indexes and full-text search

**Command Line Options:**
- `--verbose` or `-v`: Show detailed progress and creation logs
- `--dry-run` or `-d`: Preview what would be created without making database changes
- `--limit=N` or `-l N`: Process only the first N countries from the seed data
- `--help` or `-h`: Display help message with all available options

**Example Usage:**
```sh
# Basic usage - create all countries
bundle exec rake addresses:countries:create

# With verbose output to see progress
bundle exec rake addresses:countries:create --verbose

# Dry run to preview changes
bundle exec rake addresses:countries:create --dry-run

# Process only first 10 countries
bundle exec rake addresses:countries:create --limit=10

# Combine options
bundle exec rake addresses:countries:create --verbose --limit=5
```

**Example Output:**
```
Starting countries creation task...
Options: {:verbose=>true, :limit=>10}
Created: United States
Created: Canada
Progress: 2/10 (20.00%)
...
Task completed successfully!
Created: 10 countries
Skipped: 2 countries
```
```

See other tasks in `lib/tasks/populate/` for more specific population options.

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
- Rails 8: `~> 4.0`
- Rails 7: `~> 3.0`, `< 4.0`
- Rails 6: `~> 2.0`, `< 3.0`
- Rails 5: `~> 1.0.0`, `< 2.0`
- Rails <= 4: `0.0.9`, `< 1.0`

## Best Practices
- Always run migrations after updating the gem
- Use the provided rake tasks to ensure official and up-to-date data
- For custom data, extend the models and tasks as needed
- Keep your gem version in sync with your Rails version

## Rails 8 Features

### New in Version 4.0 (Rails 8 Support)
- **Rails 8 compatibility** with backward compatibility for Rails 6.1+
- **New countries:create task** for automated country data population
- **Enhanced database performance** with composite indexes and full-text search
- **Improved transaction handling** for bulk operations
- **Better error handling** with detailed progress feedback
- **ISO 3166-1 compliance** for country codes and names

### Migration from Previous Versions
When upgrading from version 3.x to 4.0:
1. Update your Gemfile: `gem 'addresses', '~> 4.0'`
2. Run `bundle update addresses`
3. Run migrations: `rake db:migrate`
4. Test your existing functionality
5. Use the new `countries:create` task to populate country data

### Database Optimizations
Version 4.0 includes Rails 8 specific database optimizations:
- Composite unique indexes on ISO codes for better performance
- Full-text search indexes for country name queries
- Generated columns for case-insensitive searches
- Enhanced transaction management for bulk operations

## License
MIT License. See [MIT-LICENSE](MIT-LICENSE) for details.

---
For more information, see the code in `lib/tasks/populate/` and the model documentation.
