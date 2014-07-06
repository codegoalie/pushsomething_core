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
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   get 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   get 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # get ':controller(/:action(/:id))(.:format)'
end
