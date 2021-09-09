Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'homes#top'
  get 'home/about' => 'homes#about'

  #deviseルーティング
  devise_for :admins, controllers: {
    sessions:      'admins/sessions',
    passwords:     'admins/passwords',
    registrations: 'admins/registrations'
  }
  devise_for :users, controllers: {
    sessions:      'users/sessions',
    passwords:     'users/passwords',
    registrations: 'users/registrations'
  }

 #ユーザールーティング
 resources :users, only: [:index, :show, :edit, :update] do
  resource :relationships, only: [:create, :destroy]
  resources :tweets, only: [:create, :destroy, :edit, :update]
  get 'followings' => 'relationships#followings', as: 'followings'
  get 'followers' => 'relationships#followers', as: 'followers'
 end

 resources :main_posts do
  resources :sub_posts, only: [:create, :destroy, :edit, :update]
  resources :comments, only: [:create, :destroy, :edit, :update]
  resource :favorites, only: [:create, :destroy]
 end

 #管理者ルーティング
 namespace :admins do
   root to: "homes#top"
   resources :main_posts, only: [:index, :show, :update, :destroy] do
     resources :comments, only: [:destroy]
   end
 end

end
