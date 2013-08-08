AngularFirst::Application.routes.draw do
  resources :tasks

  # match "/login" => "sessions#create", via: :post
  # match "/users" => "users#create", via: :post
  # match ""
  devise_for :users, skip: [:sessions, :registrations, :password] do
    post "/login" => "sessions#create"
    get "/logout" => "sessions#destroy"
    delete "/logout" => "sessions#destroy"
    post "/register" => "registrations#create"
  end
  # , :path => '', :path_names => { :sign_in => "login", :sign_out => "logout"},
  #   :controllers => { :sessions => "sessions" }

  root to: "home#index"
  match '*path', to: "home#index"
end
