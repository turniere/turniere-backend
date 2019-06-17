# frozen_string_literal: true

Rails.application.routes.draw do
  mount_devise_token_auth_for 'User', at: 'users', controllers: {
    registrations: 'overrides/registrations',
    sessions: 'overrides/sessions'
  }

  resources :matches, only: %i[show update] do
    resources :bets, only: %i[index create]
  end
  resources :teams, only: %i[show update]
  resources :tournaments do
    resources :statistics, only: %i[index]
  end
  resources :match_scores, only: %i[show update]
  resources :groups, only: %i[show]
end
