Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get "/bids", to: "bids#index"
      get "/bids/:id", to: "bids#show"
      post "/bids", to: "bids#create"
      delete "bids/:id", to: "bids#destroy"
      get "/users", to: "users#index"
      get "/users/:id", to: "users#show"
      get "/tasks", to: "tasks#index"
      get "/tasks/:id", to: "tasks#show"
      post "/tasks", to: "tasks#create"
      put "/tasks/:id", to: "tasks#update"
      patch "/tasks/:id", to: "tasks#update"
      delete "/tasks/:id", to: "tasks#destroy"
      get "/notifications", to: "notifications#index"
      put "/notifications/:id", to: "notifications#update"
      post "/watched_tasks", to: "watched_tasks#create"
      delete "/watched_tasks/:id", to: "watched_tasks#destroy"
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
