# frozen_string_literal: true

Rails.application.routes.draw do
  resources :controllers
  mount_devise_token_auth_for 'User', at: 'users'

  resources :tournaments

  resources :matches

  resources :teams
end
