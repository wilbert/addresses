Rails.application.routes.draw do
  mount Addresses::Engine => "/addresses"
end
