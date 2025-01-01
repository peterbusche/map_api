# ============= RAILS HAS STRICT NAMING CONVENTIONS TO MAKE ROUTES EASIER=================
# consult these naming conventions before writing database schema/making models
# 


Rails.application.routes.draw do
  # ================= WEB ROUTES ===================
  namespace :web do
    # Routes for users
    resources :users, only: [:index, :show, :create, :new] do
      # Nested routes for images belonging to a specific user
      resources :images, only: [:index, :create, :new]
    end

    # Routes for standalone image actions
    resources :images, only: [:index, :show, :new]

    # Session management routes
    get '/login', to: 'sessions#new', as: :login
    post '/login', to: 'sessions#create', defaults: {format: :json}
    delete '/logout', to: 'sessions#destroy', as: :logout

    # Root path for the web namespace
    root "users#index"
  end

  # ================= API ROUTES ===================
  namespace :api do
    # Define API-specific routes here
    resources :users, only: [:show, :create]
    resources :images, only: [:index, :create]
    post '/login', to: 'sessions#create', defaults: { format: :json }
  end

  # ================= COMMON ROUTES ===================
  # Health check route (common across web and API)
  get '/ping', to: 'health#ping'
end

