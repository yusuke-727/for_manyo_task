Rails.application.routes.draw do
  namespace :admin do
    resources :users # 全てのアクションのルーティングを作成
  end

  root to: 'tasks#index'

  resources :tasks

  resources :users, only: [:new, :create, :show, :edit, :update] # ユーザーに関するルーティング

  resource :session, only: [:new, :create, :destroy] # セッションに関するルーティング
  get 'login', to: 'sessions#new', as: 'login'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy', as: 'logout'
end
