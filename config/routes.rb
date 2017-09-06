Addresses::Engine.routes.draw do

    resources :cities, only: [:index]
    resources :neighborhoods, only: [:index]
    resources :states, only: [:index]

    root to: "cities#index"
end
