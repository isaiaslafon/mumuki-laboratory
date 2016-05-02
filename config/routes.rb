Rails.application.routes.draw do


  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  controller :sessions do
    get 'auth/auth0/callback' => :callback
    get 'auth/failure' => :failure
    get 'logout' => :destroy
  end

  root to: 'book#show'

  resources :book, only: [:show]
  resources :chapters, only: [:show]

  # All users
  resources :exercises, only: [:show, :index] do
    # Current user
    resources :solutions, controller: 'exercise_solutions', only: :create
    resources :queries, controller: 'exercise_query', only: :create
  end

  # All users
  resources :lessons, only: [:show, :index]

  # All users
  resources :users, only: [:show, :index]

  # Guide route
  get '/guides/:organization/:repository' => 'guides#show', as: :guide_by_slug
end
