require 'resque/server'

StoreEngine::Application.routes.draw do
  mount Resque::Server.new, at: "/resque"

  root to: 'homepage#show'

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
    resources :collections do
      member do
        put "add_product/:product_id" => "collections#add_product", as: :add_product
        put "remove_product/:product_id" => "collections#remove_product", as: :remove_product
      end
    end
  end

  resource :cart, only: [ :update, :show, :destroy ] do
    member do
      put :remove_item
    end
  end

  get "/checkout" => "checkouts#show", as: :checkout
  post "/checkout" => "checkouts#create", as: :checkout
  post "/buy_now" => "checkouts#buy_now", as: :buy_now

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

    resources :products, only: [ :show ]

    namespace :admin do
      get '/' => "dashboards#manage", as: :manage

      get '/edit' => "dashboards#edit", as: :edit_store
      put '/update' => "dashboards#update", as: :update_store

      post '/role' => "roles#create", as: :create_role
      delete '/role' => "roles#destroy", as: :revoke_role

      get :dashboard, to: "orders#index", as: :dashboard

      resources :products do
        member do
          put :toggle_status
          delete :destroy_image
        end
      end

      resources :orders, only: [ :show, :update ]
      resources :order_items, only: [ :update, :destroy]
      resources :categories, except: [ :show ]
    end
  end
end
