Rails.application.routes.draw do
  root to: "toppages#index"
  
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  
  get "signup", to: "users#new"
  # 中間テーブル favorites 先のお気に入りに登録した micropost 一覧を表示できるようにするルーティング
  resources :users, only: [:index, :show, :create] do
    member do
      get :followings
      get :followers
      get :likes
    end
  end
  
  resources :microposts, only: [:create, :destroy]
    
  resources :relationships, only: [:create, :destroy]
  # ログインユーザが投稿をお気に入りに登録/削除できるようにするルーティング
  resources :favorites, only: [:create, :destroy]
end
