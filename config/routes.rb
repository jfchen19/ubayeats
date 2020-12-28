Rails.application.routes.draw do
  devise_for :users, controllers: { 
    omniauth_callbacks: "users/omniauth_callbacks",
    registrations: "users/registrations" 
  }
  root 'home#index'
  
  resource :stores do 
    resource :orders, only: [:new] do
      get :preparing
      get :delivering
      get :record
    end
    collection do
      get :index
    end
  end
  resources :orders
  resource :carts do
    get :checkout
  end
  # , only: [:show, :destroy] do
  #   post ':add_item/:id',aciton: 'add_item' 



  resource :drivers

  resource :stores, only: [:show, :edit, :update] do
    get '/productlist', to: 'products#index'
    resources :products, shallow: true, only: [:show, :new, :create, :edit, :update, :destroy] do
      member do
        patch :publish
        patch :delist
      end
    end
  end
end
