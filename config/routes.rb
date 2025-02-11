Rails.application.routes.draw do
  devise_for :users
  
  authenticate :user do
    resources :generations, only: [:index, :new, :create, :show] do
      collection do
        get 'styles/:style/new', to: 'generations#new_style', as: :new_style
      end
      member do
        post 'like'
        delete 'unlike'
      end
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  root "home#index"
end
