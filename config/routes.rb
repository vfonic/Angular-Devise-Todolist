AngularFirst::Application.routes.draw do
  resources :tasks

  devise_for :users

  root to: "tasks#index"
end
