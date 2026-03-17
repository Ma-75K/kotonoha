Rails.application.routes.draw do
  root "top#index"

  # ヘルスチェック
  get "up" => "rails/health#show", as: :rails_health_check

  # ユーザー登録
  resources :users, only: %i[new] do
    collection do
      post :confirm # 確認用アクション
    end
  end

  # お子様登録
  resources :children, only: %i[new create] do
    # お子様切り替え機能
    member do
      post :switch
    end

    # 録音機能（お子様に紐付く）
    resources :recordings, only: %i[new create]
  end

  # ログイン・ログアウト
  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"
end
