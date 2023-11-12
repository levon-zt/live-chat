Rails.application.routes.draw do
  get '/sign_in', to: 'sessions#new'
  post '/sign_in', to: 'sessions#create'
  delete '/sign_out', to: 'sessions#destroy'

  get '/sign_up', to: 'registrations#new'
  post '/sign_up', to: 'registrations#create'

  get '/chat', to: 'chats#index'
  post '/chat', to: 'chats#create'

  root :to => 'chats#index'
end
