Rails.application.routes.draw do
  devise_for :users

  # For additional user routing
  get 'users/user', to: 'users#show', as: 'user'
  get 'users/user/edit', to: 'users#edit', as: 'edit_user'
  patch 'users/user', to: 'users#update'
  post 'users/user/start', to: 'users#start_team', as: 'start_team'

  get 'teams/:id/users', to: 'teams#new_user', as: 'new_team_user'
  post 'teams/:id/users', to: 'teams#add_user', as: 'add_team_user'
  get 'teams/:id/users/drop', to: 'teams#drop_user', as: 'drop_team_user'
  delete 'teams/:id/users/drop', to: 'teams#remove_user', as: 'remove_team_user'

  resources :teams do
    resources :users, only: :show
  end

  resources :rosters, only: [:show, :edit, :update]

  resources :messages, only: [:index, :new, :create, :show]

  resources :meals do
    resources :ingredients, only: [:create, :destroy]
  end

  resources :exercises, except: :show

  resources :weigh_ins, except: :show

  # For team messaging
  get 'teams/:team_id/messages', to: 'team_messages#index', as: 'team_messages'
  post 'teams/:team_id/messages', to: 'team_messages#create', as: 'create_team_message'
  get 'teams/:team_id/messages/new', to: 'team_messages#new', as: 'new_team_message'

  # Nutritionix query processing
  post 'meals/:id/query', to: 'meals#show', as: 'nutritionix_query'

  root 'teams#index'
end
