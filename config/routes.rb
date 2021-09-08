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

 resources :users, only: [:index, :show, :edit, :update]
 resources :main_posts do
  resources :comments, only: [:create, :destroy, :edit, :update]
 end
end
