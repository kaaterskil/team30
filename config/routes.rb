Rails.application.routes.draw do
  devise_for :users

  resources :users

  resources :teams

  root 'teams#index'
end
