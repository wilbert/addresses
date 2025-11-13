# Repository Guidelines

## Project Structure & Module Organization
Engine code lives in `app/` (`controllers`, `models`, `services`), while shared tasks and helpers live in `lib/`. Migrations sit in `db/migrate`, and specs plus fixtures occupy `spec/`. Executables in `bin/` (plus legacy helpers in `script/`) are the approved entry points; avoid editing `spec/dummy` unless you are updating the host-app example.

## Build, Test, and Development Commands
Install dependencies with `bundle install`. Use `bundle exec rspec` for the full suite or scope to a directory (e.g., `bundle exec rspec spec/services`). `bundle exec rubocop` runs the style gates. Set up a host app with `bundle exec rake addresses:install:migrations` then `bundle exec rake db:migrate`. Seed reference data through `bundle exec rake addresses:br:all` or experiment safely via `bundle exec rake addresses:countries:create --dry-run`.

## Coding Style & Naming Conventions
Follow standard Ruby two-space indentation, `snake_case` methods, and `CamelCase` modules. Group orchestration logic into service objects in `app/services` and keep controllers thin. RSpec constants and shared contexts should read `Addresses::Country` instead of relying on string evaluation. RuboCop plus the `performance`, `rails`, and `rspec` extensions enforce formatting—always run them through Bundler so the local config and version pin apply.

## Testing Guidelines
RSpec is required for unit, request, and task coverage; each file under `spec/` ends with `_spec.rb`. Factories in `spec/factories` back most examples, while WebMock/VCR protect network edges. SimpleCov boots from `spec/spec_helper`, so leave its `require` at the top and export `SIMPLECOV=1` when you need HTML reports. Add request specs for new endpoints, task specs for any Rake addition, and model specs whenever callbacks or validations change.

## Commit & Pull Request Guidelines
History shows short imperative subjects with optional scopes (`feat(countries): add Rails 8 compatibility`). Mirror that style, mention the data task or migration that needs to run, and keep body paragraphs wrapped at 80 columns. Pull requests must explain the motivation, outline testing done (`bundle exec rspec`, `bundle exec rubocop`, specific population tasks), and link issues when relevant. Include screenshots or console snippets for API or task output so reviewers can confirm behavior without re-running heavy imports.

## Data & Configuration Tips
CSV or JSON seeds belong under `lib/addresses/tasks` so they are packaged with the gem. After changing migrations, re-run `bundle exec rake app:db:migrate` inside the dummy app to validate install scripts. Use `bundle exec rake addresses:clean` only in disposable databases; it truncates every table the engine manages.
