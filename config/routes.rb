Addresses::Engine.routes.draw do
  resources :cities, only: :index

  resources :neighborhoods, only: :index

  get 'zipcodes/:zipcode', to: 'zipcodes#show', constraints: { zipcode: /\d{8}/ }, as: :zipcode
end
