Rails.application.routes.draw do
  resources :sessions, only: [:new, :create, :destroy]
  resources :registrations, only: [:new, :create]
  
  root :to => 'authentication#sign_in'
end
