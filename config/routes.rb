Rails.application.routes.draw do
  resources :users, only: [:index]
  resources :accounts, only: [:index, :new, :create, :edit, :update, :show, :destroy] do
    collection do
      get :manage_accounts
    end
  end
  resources :auctions, only: [:index, :new, :create, :edit, :update, :show, :destroy] do
    collection do
      get :manage_auctions
    end
  end
  get 'home/index'
  get 'about', to: 'home#about'
  root to: 'home#index'

  devise_for :users,
             controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
end
