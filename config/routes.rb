StoreEngine::Application.routes.draw do
  root to: 'stores#index'

  get "/code" => redirect("http://github.com/raphweiner/son_of_store_engine")
  put "/i18n" => "i18n#update"

  delete "/logout" => "sessions#destroy", as: :logout
  get "/login" => "sessions#new", as: :login
  resources :sessions, only: [ :create ]

  get "/signup" => "users#new", as: :signup
  resources :users, only: [ :create, :update ] do
    resources :orders, except: [ :show ]
  end

  scope path: "account", as: "account" do
    get "/profile" => "users#show", as: :profile
    get "/orders" => "orders#index", as: :orders
    get "/orders/:id" => "orders#show", as: :order
  end

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
    get "/checkout" => "checkout#show", as: :checkout
    post "/buy_now" => "orders#buy_now", as: :buy_now

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
