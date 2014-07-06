PushRails::Application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get 'sign-in', to: 'devise/sessions#new', as: :new_session
    get 'sign-out', to: 'devise/sessions#destroy', as: :destroy_session
  end

  resources :receivers, only: [:index, :show, :edit, :update]
  resources :notifications, only: [:index, :create]
  resources :services

  namespace :api do
    namespace :v1 do
      resources :receivers, only: :create
      resources :acknowledgements, only: :create
      resources :notifications, only: :create
    end
  end

  require 'sidekiq/web'
  authenticate :user, -> (u) { u.admin? } do
    mount Sidekiq::Web => '/jobs'
  end

  post '/facebook', to: 'facebook#create', as: :create_facebook
  get '/facebook/show', to: 'facebook#show', as: :show_facebook

  resources :welcome, only: [:index]
  get '/docs', to: 'welcome#docs', as: :docs
  root to: 'welcome#index'
end
