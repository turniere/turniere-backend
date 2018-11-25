# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'users'

  resources :matches, only: %i[show]
  resources :teams, only: %i[show update]
  resources :tournaments
end
