Rails.application.routes.draw do
  namespace :admin do
    resources :users, only: [:index,:new, :create, :show, :edit, :update]
  end


  root to: 'tasks#index'

  resources :tasks

  resources :users, only: [:new, :create, :show, :edit, :update]

  resource :session, only: [:new, :create, :destroy]
  
  post 'session/new_session', to: 'sessions#create', as: 'create_session'
  delete 'logout', to: 'sessions#destroy', as: 'logout'
end

