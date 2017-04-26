Rails.application.routes.draw do
  resources :users, only: [:index]

  resources :accounts, only: [:new, :create, :edit, :update, :show, :destroy] do
    collection do
      get :manage_accounts
      get :bought_accounts
    end
  end

  resources :auctions, only: [:index, :new, :create, :edit, :update, :show, :destroy] do
    resources :bids
    collection do
      get :manage_auctions
    end
    member do
      patch :start, :buy_immediately, :close
    end
  end

  get 'about', to: 'home#about'
  root to: 'home#index'

  devise_for :users,
             controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
end
