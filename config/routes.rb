Rails.application.routes.draw do
  resources :tasks
  resources :activities
  devise_for :users

  namespace :api do
    devise_scope :user do
      post   "login",  to: "sessions#create"
      delete "logout", to: "sessions#destroy"
    end

    resources :tasks, only: [ :index, :show ] do
      post :transition
    end
  end

  namespace :rui do
    get "about", to: "pages#about"
    get "pricing", to: "pages#pricing"
    get "dashboard", to: "pages#dashboard"
    get "projects", to: "pages#projects"
    get "project", to: "pages#project"
    get "messages", to: "pages#messages"
    get "message", to: "pages#message"
    get "assignments", to: "pages#assignments"
    get "calendar", to: "pages#calendar"
    get "people", to: "pages#people"
    get "profile", to: "pages#profile"
    get "activity", to: "pages#activity"
    get "settings", to: "pages#settings"
    get "notifications", to: "pages#notifications"
    get "billing", to: "pages#billing"
    get "team", to: "pages#team"
    get "integrations", to: "pages#integrations"
  end

  if Rails.env.development?
    # Visit the start page for Rails UI any time at /railsui/start
    mount Railsui::Engine, at: "/railsui"
  end


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  get "pages/home"
  # Defines the root path route ("/")
  root "pages#home"

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
end
