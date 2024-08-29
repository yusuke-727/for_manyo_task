Rails.application.routes.draw do
  namespace :admin do
    resources :users, path_names: {
      new: 'new_admin_user',
      edit: 'edit_admin_user',
      show: 'admin_user'
    }
  end

  root to: 'tasks#index'

  resources :tasks

  resources :users, only: [:new, :create, :show, :edit, :update], path: 'user', path_names: {
    new: 'new_user',
    edit: 'edit_user'
  }

  resource :session, only: [:new, :create, :destroy], path_names: {
    new: 'new_session'
  }
  
  # get 'login', to: 'sessions#new', as: 'login'
  post 'session/new_session', to: 'sessions#create', as: 'create_session'
  delete 'logout', to: 'sessions#destroy', as: 'logout'
end

