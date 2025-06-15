#!/bin/bash
set -e

# Store the current directory
ROOT_DIR=$(pwd)

# Navigate to the dummy app
cd spec/dummy

# Make sure we're in the right directory
echo "Current directory: $(pwd)"

# Install dependencies
echo "\nInstalling dependencies..."
bundle config set --local path 'vendor/bundle'
bundle install

# Create and migrate the database
echo "\nSetting up database..."
bundle exec rails db:create db:migrate

# Go back to root directory
cd "$ROOT_DIR"

# Run the cities extraction task
echo -e "\nExtracting cities from ceps.csv..."
bundle exec rake extract:cities

# Run the cities population task
echo -e "\nPopulating cities..."
cd spec/dummy
bundle exec rake addresses:br:cities

echo -e "\nDone!"
