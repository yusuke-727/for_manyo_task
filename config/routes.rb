Rails.application.routes.draw do
  namespace :admin do
    resources :users, only: [:index, :new, :create, :show, :edit, :update]    
  end


  #:index,:new, :create, :show, :edit, :update

  root to: 'tasks#index'

  resources :tasks

  #resources :users, only: [:new, :create, :show, :edit, :update]
  #アカウント登録画面
  get 'users/new_user', to: 'users#new', as: 'new_user'
  post 'users', to: 'users#create'

  #アカウント詳細画面
  get 'users/:id', to: 'users#show', as: 'user'

  #アカウント編集画面
  get 'users/:id/edit_user', to: 'users#edit', as: 'edit_user'
  patch 'users/:id', to: 'users#update'
  put 'users/:id', to: 'users#update'


  #ログイン画面
  #resource :session, only: [:new, :create, :destroy]
  get 'session/new_session', to: 'sessions#new', as: 'new_session'
  post 'session', to: 'sessions#create'

  delete 'logout', to: 'sessions#destroy', as: 'logout'
end

