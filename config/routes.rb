Rails.application.routes.draw do
  get 'user/index'

  get 'home/index'

  devise_for :users
  root to: 'home#index'
end
