AngularFirst::Application.routes.draw do
  resources :tasks

  devise_for :users, :path => '', :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register" }
  match "/users" => "users#create", via: :post

  root to: "tasks#index"
  match '*path', to: "tasks#index"
end
