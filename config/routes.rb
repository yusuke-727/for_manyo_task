Rails.application.routes.draw do
  namespace :admin do
    resources :users, only: [:index, :new, :create, :show, :edit, :update, :destroy] 
  end

  root to: 'tasks#index'

  resources :tasks

  resources :users, only: [:new, :create, :show, :edit, :update, :destroy]
  
  get 'session/new_session', to: 'sessions#new', as: 'new_session'
  post 'session/new_session', to: 'sessions#create'

  delete 'logout', to: 'sessions#destroy', as: 'logout'
end

