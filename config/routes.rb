Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # Root route
  root "home#index"
  
  # Generation routes
  resources :generations do
    collection do
      get 'new/:style', action: :new_style, as: :new_style
    end
  end

  # Style catalog routes with analytics
  resources :styles, only: [:index, :show] do
    member do
      get :gallery    # Shows example generations
      get :reviews    # User reviews and ratings
      get :analytics  # Advanced stats and trends
      post :try      # Redirects to new generation with this style
    end

    collection do
      get :trending # Shows trending styles
      get 'category/:category', to: 'styles#category', as: :style_category # New route for category filtering
    end
  end
end
