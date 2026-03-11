Rails.application.routes.draw do
  get "user_sessions/new"
  get "user_sessions/create"
  get "user_sessions/destroy"
  root 'top#index'
  # ヘルスチェック
  get "up" => "rails/health#show", as: :rails_health_check

  resources :users, only: [:new, :create]
  resources :children, only: [:new, :create]

  resources :children do
    resources :recordings, only: [:new, :create]
  end

  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"
end
