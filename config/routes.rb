Rails.application.routes.draw do
  devise_for :users

  resources :teams do
    resources :users, only: :show
  end

  resources :users, only: [:show, :edit, :update]

  resources :messages, only: [:index, :new, :create]

  resources :meals do
    resources :ingredients, only: [:create, :destroy]
  end

  # For team messaging
  get 'teams/:team_id/messages', to: 'messages#team_index', as: 'team_messages_path'
  post 'teams/:team_id/messages', to: 'messages#team_create', as: 'create_team_message_path'
  get 'teams/:team_id/messages/new', to: 'messages#team_new', as: 'new_team_message_path'

  # Nutritionix query processing
  post 'meals/:id/query', to: 'meals#show', as: 'nutritionix_query'

  root 'teams#index'
end
