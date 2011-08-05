Migrations::Application.routes.draw do
  resource :session, :only => [:new, :create, :destroy]
  match '/login' => 'sessions#new', :as => :login
  match '/logout' => 'sessions#destroy', :as => :logout
  match '/not_authorized' => 'sessions#not_authorized', :as => :not_authorized
  match '/auth/:provider/callback' => 'sessions#create'

  root :to => 'users#index'

  resources :groups

  resources :users

  resources :resources

  resources :profiles

  resources :devices

  resources :migrations

  namespace :admin do
    
  end
end
