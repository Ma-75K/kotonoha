require 'rails_helper'

RSpec.describe "Favorites", type: :request do
  def login_as(user)
    post login_path, params: {
      email: user.email,
      password: "password"
    }
  end
  describe "POST /children/:child_id/recordings/:recording_id/favorite" do
    it "お気に入り登録できる" do
      user = create(:user, password: "password", password_confirmation: "password")
      child = create(:child, user: user)
      recording = create(:recording, user: user, child: child)

      login_as(user)

      expect {
        post child_recording_favorite_path(child, recording)
      }.to change(Favorite, :count).by(1)

      expect(response).to have_http_status(:redirect)
    end

    it "未ログイン時はログイン画面へリダイレクトされる" do
      user = create(:user)
      child = create(:child, user: user)
      recording = create(:recording, user: user, child: child)

      post child_recording_favorite_path(child, recording)

      expect(response).to redirect_to(login_path)
    end

    it "他ユーザーの録音はお気に入りできない" do
      user = create(:user, password: "password", password_confirmation: "password")
      create(:child, user: user)

      other_user = create(:user)
      other_child = create(:child, user: other_user)
      other_recording = create(:recording, user: other_user, child: other_child)

      login_as(user)

      expect {
        post child_recording_favorite_path(other_child, other_recording)
      }.not_to change(Favorite, :count)
    end
  end

  describe "DELETE /children/:child_id/recordings/:recording_id/favorite" do
    it "お気に入り解除できる" do
      user = create(:user)
      child = create(:child, user: user)
      recording = create(:recording, user: user, child: child)
      create(:favorite, user: user, recording: recording)

      login_as(user)

      expect {
        delete child_recording_favorite_path(child, recording)
    }.to change(Favorite, :count).by(-1)

      expect(response).to have_http_status(:redirect)
    end
  end
end
