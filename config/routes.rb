Rails.application.routes.draw do
  # Defines the root path ("/")
  root "dashboard#index"

  devise_for :users
  resources :products
  get 'cart', to: 'carts#index', as: :cart

  resources :carts, only: [:index, :destroy, :update] do
    member do
      get 'checkout'
      patch 'add_to_cart', to: 'carts#update', as: :add_to_cart
      patch 'update_quantity', to: 'carts#update', as: :update_quantity
    end
  end
  resources :orders, only: [:index, :show, :create]
end
