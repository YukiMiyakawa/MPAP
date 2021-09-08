Rails.application.routes.draw do
  # devise_for :users
  # devise_for :admins
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'homes#top'
  get 'home/about' => 'homes#about'

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

 resources :users, only: [:index, :show, :edit, :update] do
  resource :relationships, only: [:create, :destroy]
  get 'followings' => 'relationships#followings', as: 'followings'
  get 'followers' => 'relationships#followers', as: 'followers'
 end

 resources :main_posts do
  resources :sub_posts, only: [:create, :destroy, :edit, :update]
  resources :comments, only: [:create, :destroy, :edit, :update]
  resource :favorites, only: [:create, :destroy]
 end

end
