# frozen_string_literal: true

Rails.application.routes.draw do
  resources :games
  resources :rounds, except: :index
end
