Addresses::Engine.routes.draw do
  resources :states

  resources :cities do
    get :autocomplete_city_name, :on => :collection
    get "per_state/:state_id", to: "cities#index", :on => :collection
  end

  resources :neighborhoods

  root to: "cities#index"
end
