require 'resque/server'

StoreEngine::Application.routes.draw do
  mount Resque::Server.new, at: "/resque"

  root to: 'stores#index'

  get "/code" => redirect("http://github.com/raphweiner/son_of_store_engine")
  put "/i18n" => "i18n#update"

  delete "/logout" => "sessions#destroy", as: :logout
  get "/login" => "sessions#new", as: :login
  resources :sessions, only: [ :create ]

  get "/users/new" => "users#new", as: :signup
  resources :users, only: [ :create, :update ]

  get "/profile" => "users#show", as: :profile
  
  scope path: "account", as: "account" do
    get "/orders" => "orders#index", as: :orders
  end

  get "/orders/:guid" => "orders#show", as: :order

  resources :stores, only: [ :new, :create ]

  namespace :uber do
    resources :stores, only: [ :index ] do
      member do
        put :approve
        put :decline
        put :toggle_online_status
      end
    end
  end

  scope "/:store_path", as: :store do
    get "/" => "products#index", as: :home

    get "/checkout" => "checkouts#show", as: :checkout
    post "/checkout" => "checkouts#create", as: :checkout
    post "/buy_now" => "checkouts#buy_now", as: :buy_now

    resources :products, only: [ :show ]

    resource :cart, only: [ :update, :show, :destroy ] do
      member do
        put :remove_item
      end
    end

    namespace :admin do
      get :dashboard, to: "orders#index", as: :dashboard

      resources :products do
        member do
          post :toggle_status
        end
      end

      resources :orders, only: [ :show, :update ]
      resources :order_items, only: [ :update, :destroy]
      resources :categories, except: [ :show ]
    end
  end
end
