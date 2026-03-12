Rails.application.routes.draw do
  # ルートパスをstatic_pages コントローラーのtopアクションに設定
  root "static_pages#top"
  # ヘルスチェック
  get "up" => "rails/health#show", as: :rails_health_check

  resources :users, only: [ :new, :create ]
  resources :children, only: [ :new, :create ]

  resources :children do
    resources :recordings, only: [ :new, :create ]
  end
end
