# frozen_string_literal: true

Addresses::Engine.routes.draw do
  resources :countries, only: [:index, :show]
  resources :regions, only: [:index, :show]
  resources :cities, only: [:index, :show]
  resources :neighborhoods, only: [:index, :show]
  resources :states, only: [:index, :show]

  get 'zipcodes/:zipcode', to: 'zipcodes#show', constraints: { zipcode: /\d{8}/ }, as: :zipcode
end
