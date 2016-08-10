Rails.application.routes.draw do
  mount Addresses::Engine => "/addresses", as:'addresses' 
end
