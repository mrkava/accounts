Rails.application.routes.draw do
  resources :users, only: [:index, :show]
  get 'home/index'

  devise_for :users
  root to: 'home#index'
end
