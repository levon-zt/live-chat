Rails.application.routes.draw do
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  delete '/sign_out', to: 'sessions#destroy'

  get '/sign_up', to: 'registrations#new'
  post '/sign_up', to: 'registrations#create'

  resources :chats, only: [:index, :show, :create], constraints: { id: /[0-9]+/ }
  get "/chats/search", to: 'chats#search'

  match '/*', to: 'application#index', via: :all

  root :to => 'chats#index'
end
