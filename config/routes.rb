AngularFirst::Application.routes.draw do

  put "/tasks/:id/complete" => "tasks#complete"
  put "/tasks/:id/:direction" => "tasks#up_down"
  put "/tasks/:id/:direction" => "tasks#up_down"
  resources :tasks

  devise_for :users, skip: [:sessions, :registrations, :password]
  devise_scope :user do
    post "/login" => "sessions#create"
    get "/logout" => "sessions#destroy"
    delete "/logout" => "sessions#destroy"
    post "/register" => "devise/registrations#create"
  end

  root to: "home#index"
  match '*path', to: "home#index"
end
