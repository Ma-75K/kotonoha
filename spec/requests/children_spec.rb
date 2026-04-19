require "rails_helper"

RSpec.describe "Children", type: :request do
  let(:user) { create(:user, password: "password", password_confirmation: "password") }
  let!(:child1) { create(:child, user: user, name: "さき") }
  let!(:child2) { create(:child, user: user, name: "みなと") }

  before do
    post login_path, params: {
      email: user.email,
      password: "password"
    }
  end

  describe "POST /children/:id/switch" do
    it "子ども切り替えができる" do
      post switch_child_path(child2)

      expect(response).to redirect_to(new_child_recording_path(child2))
    end
  end

  describe "GET /children/new_from_settings" do
    it "設定画面から子ども追加画面を表示できる" do
      get new_from_settings_children_path

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /children/create_from_settings" do
    it "設定画面から子どもを追加できる" do
      expect {
        post create_from_settings_children_path, params: {
          child: {
            name: "みなと",
            birthday: "2023-10-02"
          }
        }
      }.to change(Child, :count).by(1)

      expect(response).to redirect_to(settings_path)
    end
  end

  describe "GET /children/:id/edit" do
    it "子ども編集画面を表示できる" do
      get edit_child_path(child1)

      expect(response).to have_http_status(:success)
    end
  end

  describe "PATCH /children/:id" do
    it "子ども情報を更新出来る" do
      patch child_path(child1), params: {
        child: {
          name: "さきちゃん",
          birthday: child1.birthday
        }
      }

      expect(response).to redirect_to(settings_path)
      expect(child1.reload.name).to eq("さきちゃん")
    end
  end

  describe "DELETE /children/:id" do
    it "子どもを削除できる" do
      expect {
        delete child_path(child1)
      }.to change(Child, :count).by(-1)

      expect(response).to redirect_to(settings_path)
    end
  end

  describe "DELETE /children/:id" do
    it "最後の1人は削除できない" do
      child1.destroy
      only_child = child2

      expect {
        delete child_path(only_child)
      }.not_to change(Child, :count)

      expect(response).to redirect_to(edit_child_path(only_child))
    end
  end

  describe "他人の子どもへのアクセス" do
    it "他人の子どもの編集画面にアクセスはできない" do
      other_user = create(:user, email: "other@example.com", password: "password", password_confirmation: "password")
      other_child = create(:child, user: other_user)

      get edit_child_path(other_child)

      expect(response).to redirect_to(root_path)
      expect(flash[:alert]).to eq("指定されたデータが見つかりませんでした")
    end
  end
end
