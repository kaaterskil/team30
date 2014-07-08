Rails.application.routes.draw do
  devise_for :users

  resources :teams

  root 'teams#index'
end
