require 'rails_helper'

RSpec.describe "UserSessions", type: :request do
  describe "POST /login" do
    it "正しい情報でログインできる" do
      user = create(:user, password: "password", password_confirmation: "password")
      child = create(:child, user: user)

      post login_path, params: {
        email: user.email,
        password: "password"
      }

      expect(response).to redirect_to(new_child_recording_path(child))
    end

    it "間違った情報ではログインできない" do
      user = create(:user, password: "password", password_confirmation: "password")

      post login_path, params: {
        email: user.email,
        password: "wrong_password"
      }

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "DELETE /logout" do
    it "ログアウトできる" do
      user = create(:user, password: "password", password_confirmation: "password")
      child = create(:child, user: user)

      post login_path, params: {
        email: user.email,
        password: "password"
      }

      delete logout_path

      expect(response).to redirect_to(root_path)
    end
  end

  describe "認証が必要なページ" do
    it "未ログインで設定画面にアクセスするとログイン画面にリダイレクトする"  do
      get settings_path

      expect(response).to redirect_to(login_path)
    end
  end
end
