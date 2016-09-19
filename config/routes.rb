Addresses::Engine.routes.draw do
  resources :cities, only: :index

  resources :neighborhoods, only: :index

end
