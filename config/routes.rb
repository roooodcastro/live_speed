# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  mount ActionCable.server => '/cable'

  resource :lobby, only: [:show], controller: :lobby

  resources :matches do
    collection { post :join }
    member { get :play }
  end

  resource :my_account, only: %i[show edit update destroy], controller: :my_account
  resources(:players, only: %i[new create]) { collection { get :validate } }
  resources :rounds, except: :index
  resource :sessions, only: %i[show new create destroy]
  resources(:users) { collection { get :validate } }

  get :how_to_play, to: 'static_pages#how_to_play'
end
