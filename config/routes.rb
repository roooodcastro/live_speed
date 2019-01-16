# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  mount ActionCable.server => '/cable'

  resources :matches
  resources :rounds, except: :index
end
