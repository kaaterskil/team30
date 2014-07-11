Rails.application.routes.draw do
  devise_for :users

  # For additional user routing
  get 'users/user', to: 'users#show', as: 'user'
  get 'users/user/edit', to: 'users#edit', as: 'edit_user'
  patch 'users/user', to: 'users#update'

  resources :teams do
    resources :users, only: :show
  end

  resources :messages, only: [:index, :new, :create]

  resources :meals do
    resources :ingredients, only: [:create, :destroy]
  end

  resources :exercises, except: :show

  resources :weigh_ins, except: :show

  # For team messaging
  get 'teams/:team_id/messages', to: 'messages#team_index', as: 'team_messages'
  post 'teams/:team_id/messages', to: 'messages#team_create', as: 'create_team_message'
  get 'teams/:team_id/messages/new', to: 'messages#team_new', as: 'new_team_message'

  # Nutritionix query processing
  post 'meals/:id/query', to: 'meals#show', as: 'nutritionix_query'

  root 'teams#index'
end
