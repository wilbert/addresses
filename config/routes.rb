Addresses::Engine.routes.draw do
  resources :cities

  resources :neighborhoods

  root to: "cities#index"
end
