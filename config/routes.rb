AngularFirst::Application.routes.draw do
  resources :tasks

  match "/users" => "users#create", via: :post
  devise_for :users, :path => '', :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register" },
    :controllers => { :sessions => "sessions" }

  root to: "tasks#index"
  match '*path', to: "tasks#index"
end
