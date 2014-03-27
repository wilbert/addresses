Addresses::Engine.routes.draw do
    resources :cities

    root to: "cities#index"
end
