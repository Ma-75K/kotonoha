require "rails_helper"

RSpec.describe "Children registration flow", type: :request do
  describe "GET /children/new" do
    it "session[:user_params] がない場合はユーザー登録画面にリダイレクトする" do
      get new_child_path

      expect(response).to redirect_to(new_user_path)
    end
  end

  describe "POST /children" do
    it "session[:user_params] がない場合はユーザー登録画面にリダイレクトする" do
      post children_path, params: {
        child: {
          name: "ことちゃん",
          birthday: "2022-07-28"
        }
      }

      expect(response).to redirect_to(new_user_path)
    end

    it "confirm を通ったあと、ユーザーと子どもを作成出来る" do
      user_params = {
        name: "テストユーザー",
        email: "test@example.com",
        password: "password",
        password_confirmation: "password"
      }

      child_params = {
        user: {
          children_attributes: {
            "0" => {
              name: "ことちゃん",
              birthday: "2022-07-28"
            }
          }
        }
      }

      post confirm_users_path, params: { user: user_params }

      expect {
        post children_path, params: child_params
      }.to change(User, :count).by(1)
       .and change(Child, :count).by(1)

     expect(response).to redirect_to(new_child_recording_path(Child.last))
    end

    it "子ども情報が不正な場合は登録に失敗する" do
      user_params = {
        name: "テストユーザー",
        email: "invalid_test@example.com",
        password: "password",
        password_confirmation: "password"
      }

      invalid_child_params = {
        user: {
          children_attributes: {
            "0" => {
              name: nil,
              birthday: nil
            }
          }
        }
      }

      post confirm_users_path, params: { user: user_params }
      post children_path, params: invalid_child_params

      expect(response).to have_http_status(:unprocessable_entity)
    end

    it "子ども情報が不正な場合は、User と Child が保存されない" do
      user_params = {
        name: "テストユーザー",
        email: "rollback_test@example.com",
        password: "password",
        password_confirmation: "password"
      }

      invalid_child_params = {
        user: {
          children_attributes: {
            name: nil,
            birthday: nil
          }
        }
      }

      post confirm_users_path, params: { user: user_params }

      expect {
        post children_path, params: invalid_child_params
      }.not_to change(User, :count)

      expect(Child.count).to eq(0)
    end
  end
end
