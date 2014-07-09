Rails.application.routes.draw do
  devise_for :users

  resources :teams do
    resources :users, only: :show
  end

  resources :users, only: [:show, :edit, :update] do
    resources :messages, only: [:index, :new, :create]
  end

  get 'teams/:team_id/messages', to: 'messages#team_index', as: 'team_messages_path'
  post 'teams/:team_id/messages', to: 'messages#team_create', as: 'create_team_message_path'
  get 'teams/:team_id/messages/new', to: 'messages#team_new', as: 'new_team_message_path'

  root 'teams#index'
end
