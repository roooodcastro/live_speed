# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  mount ActionCable.server => '/cable'

  resource :how_to_play, only: :show, controller: :how_to_play
  resource :lobby, only: [:show], controller: :lobby

  resources :matches do
    collection { post :join }
    member { get :play }
  end

  resources :players, only: %i[new create]
  resources :player_name_validators, only: :create
  resources :rounds, except: :index
  resource :sessions, only: %i[new create destroy]
end
