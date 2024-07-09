Rails.application.routes.draw do
  devise_for :users, controllers: { 
    registrations: 'users/registrations', 
    sessions: 'users/sessions'
  }
  
  devise_scope :user do
    get 'edit_account', to: 'users/registrations#edit_account'
    get 'profile', to:'users/sessions#profile'
  end

  resources :stores, only: [:show, :create], param: :google_place_id do
    resources :prices, only: [:new, :create, :index]
    resource :favorites, only: [:create, :update, :edit, :destroy]
  end

  resources :prices, only: [:edit, :destroy, :update] do
    collection do
      get 'own', to: 'prices#own_prices'
      get 'own_prices_result', to: 'prices#own_result'
    end
  end

  resources :favorites, only: [] do
    collection do
      get 'my_stores', to: 'favorites#index'
    end
  end

  resources :products
  get 'result', to: 'prices#result'
  root to: 'home#index'
end
