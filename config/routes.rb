# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'users'

  post '/users', to: 'user#create'
  post '/users/sign_in', to: 'user#sign_in'
  get '/users/:username', to: 'user#get'
  put '/users/:username', to: 'user#put'
  delete '/users/:username', to: 'user#delete'

  post '/tournaments', to: 'tournament#post'
  get '/tournaments/:code', to: 'tournament#get'
  put '/tournaments/:code', to: 'tournament#put'

  get '/matches/:id', to: 'match#get'
  put '/matches/:id', to: 'match#put'

  get '/teams/:id', to: 'team#get'
  put '/teams/:id', to: 'team#put'
end
