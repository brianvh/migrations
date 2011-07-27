Migrations::Application.routes.draw do
  resource :session, :only => [:new, :create, :destroy]
  match '/login' => 'sessions#new', :as => :login
  match '/logout' => 'sessions#destroy', :as => :logout
  match '/auth/:provider/callback' => 'sessions#create'
end
