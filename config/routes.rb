Rails.application.routes.draw do
  resources :watched_tasks
  resources :users
  resources :tasks
  resources :notifications
  resources :bids
  get '/', to: 'tasks#index'
end
