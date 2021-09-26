Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # deviseルーティング
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
  }
  devise_for :admins, controllers: {
    sessions: 'admins/sessions',
    passwords: 'admins/passwords',
    registrations: 'admins/registrations',
  }

  root to: 'homes#top'

  # ユーザールーティング
  resources :users, only: [:index, :show, :edit, :update] do
    resource :relationships, only: [:create, :destroy]
    resources :tweets, only: [:create, :destroy, :edit, :update]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
    resources :user_music_genres, only: [:create, :destroy]
    resources :user_instruments, only: [:create, :destroy]
    resources :tasks, only: [:create, :destroy]
  end

  get 'users/:user_id/tweets/:id' => 'tweets#edit'

  # 問い合わせ
  get 'inquirys/index'
  get 'inquirys/confirm'
  get 'inquirys/thanks'

  # 検索
  get 'search' => 'searches#search', as: 'search'
  get 'one_tag_search/:id' => 'searches#one_tag_search', as: 'one_tag_search'

  # ソート
  get 'index_sort' => 'searches#index_sort', as: 'index_sort'
  get 'result_sort' => 'searches#result_sort', as: 'result_sort'
  get 'result_tag_sort' => 'searches#result_tag_sort', as: 'result_tag_sort'

  # 退会ルーティング
  get 'unsubscribe/:name' => 'users#unsubscribe', as: 'confirm_unsubscribe'
  patch ':id/withdraw/:name' => 'users#withdraw', as: 'withdraw_user'
  put 'withdraw/:name' => 'users#withdraw'

  resources :main_posts do
    resources :sub_posts, only: [:create, :destroy, :edit, :update]
    resources :comments, only: [:create, :destroy, :edit, :update]
    resource :favorites, only: [:create, :destroy]
    resource :book_marks, only: [:create, :destroy]
  end

  get 'main_posts/:id/sub_posts' => 'main_posts#show'
  get 'main_posts/:main_post_id/comments/:id' => 'comments#edit'
  get 'main_posts/:main_post_id/sub_posts/:id' => 'sub_posts#edit'

  # ブックマーク一覧
  get 'book_marks/:id' => 'book_marks#index', as: 'book_marks'

  # タグ一覧
  resources :tags, only: [:index]

  # 会員の投稿記事一覧
  get 'user_main_post/:id' => 'main_posts#user_main_post', as: 'user_main_post'

  # 問い合わせ
  get   'inquirys'         => 'inquirys#index'     # 入力画面
  post  'inquirys/confirm' => 'inquirys#confirm'   # 確認画面
  post  'inquirys/thanks'  => 'inquirys#thanks'    # 送信完了画面

  # DM機能
  resources :messages, only: [:create, :destroy]
  resources :rooms, only: [:create, :index, :show]

  # 通知一覧
  resources :notifications, only: :index

  # 管理者ルーティング
  namespace :admins do
    root to: "homes#top"
    resources :main_posts, only: [:index, :show, :update, :destroy] do
      resources :comments, only: [:destroy]
    end
    resources :users
    resources :instruments, only: [:index, :create, :destroy, :edit, :update]
    resources :music_genres, only: [:create, :destroy, :edit, :update]
  end

  get 'admins/instruments/:id' => 'admins/instruments#edit'
  get 'admins/music_genres/:id' => 'admins/music_genres#edit'
  get 'admins/users/:id' => 'admins/users#edit'
end
