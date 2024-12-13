Rails.application.routes.draw do
  get "checkout/new"
  get "checkout/create"
  get "static_pages/show"
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  root "products#index"
  resources :products, only: [ :index, :show ]
  get "/pages/:slug", to: "static_pages#show", as: :page

  resources :categories, only: [] do
    resources :products, only: :index
  end

  resources :checkout, only: [ :new, :create, :show ] do
    collection do
      get :cancel
      get :success
      post :create_payment
    end
  end

  devise_for :users

  post "/cart/add", to: "carts#add", as: "add_to_cart"
  patch "/cart/update", to: "carts#update", as: "update_cart"
  delete "/cart/remove", to: "carts#remove", as: "remove_from_cart"
  get "/cart", to: "carts#show", as: "cart"

  resources :checkout, only: [ :new, :create, :show ]

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  # root "posts#index"
end
