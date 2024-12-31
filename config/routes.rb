# ============= RAILS HAS STRICT NAMING CONVENTIONS TO MAKE ROUTES EASIER=================
# consult these naming conventions before writing database schema/making models

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Define routes for users

  resources :users, only: [:index, :show, :create, :new] do
    # Nested routes for images belonging to a specific user
    resources :images, only: [:index, :create, :new]
  end

  # Define routes for standalone image actions
  resources :images, only: [:index, :show, :new]

  get '/login', to: 'sessions#new', as: :login
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy', as: :logout

  # Health check route
  get '/ping', to: 'health#ping'

  # Root path
  root "users#index" 
end
