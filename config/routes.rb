# frozen_string_literal: true

Rails.application.routes.draw do
  root to: 'home#index'

  resources :games
  resources :rounds, except: :index
end
