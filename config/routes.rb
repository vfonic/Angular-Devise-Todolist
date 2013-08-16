ToptalTodolist::Application.routes.draw do

  put "/tasks/clear_completed" => "tasks#clear_completed"
  put "/tasks/:id/complete" => "tasks#complete"
  put "/tasks/reorder" => "tasks#reorder"
  put "/tasks/:id/:direction" => "tasks#up_down"
  resources :tasks

  devise_for :users, skip: :all
  devise_scope :user do
    post "/login" => "sessions#create"
    get "/logout" => "sessions#destroy"
    delete "/logout" => "sessions#destroy"
    post "/register" => "devise/registrations#create"
  end

  namespace :api, :defaults => { :format => 'json' } do
    namespace :v1 do
        put "/tasks/clear_completed" => "tasks#clear_completed"
        put "/tasks/:id/complete" => "tasks#complete"
        put "/tasks/reorder" => "tasks#reorder"
        put "/tasks/:id/:direction" => "tasks#up_down"
      resources :tasks
    end
  end

  root to: "home#index"
  match '*path', to: "home#index"
end
