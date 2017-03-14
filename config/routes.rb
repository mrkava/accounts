Rails.application.routes.draw do
  resources :users, only: [:index, :show]
  get 'home/index'
  root to: 'home#index'

  devise_for :users,
             controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
end
