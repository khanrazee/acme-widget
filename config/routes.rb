Rails.application.routes.draw do
  devise_for :users
  
  resources :products
  
  post 'add_to_cart', to: 'carts#add_to_cart', as: :add_to_cart
  get 'cart', to: 'carts#index', as: :cart
  
  resources :carts, only: [:index, :show, :destroy] do
    member do
      patch 'update_quantity/:product_id', to: 'carts#update_quantity', as: :update_quantity
      get 'checkout'
    end
  end
  
  resources :orders, only: [:index, :show, :create]
  
  # Defines the root path ("/")
  root "home#index"
end
