Rails.application.routes.draw do
  get "settings/show"
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
  resources :children, only: %i[new create edit update destroy] do
    collection do
      get :new_from_settings
      post :create_from_settings
    end

    # お子様切り替え機能
    member do
      post :switch
    end

    # 録音機能（お子様に紐付く）
    resources :recordings, only: %i[index new create show edit update destroy] do
      collection do
        get :preview
        get :on_this_day
      end
    end
  end

  # ログイン・ログアウト
  get "login", to: "user_sessions#new"
  post "login", to: "user_sessions#create"
  delete "logout", to: "user_sessions#destroy"

  # 設定画面
  get "settings", to: "settings#show"

  resource :user, only: [] do
    get :edit_name
    patch :update_name
    get :edit_email
    patch :update_email
  end

  resource :password_reset, only: %i[new create edit update]

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
