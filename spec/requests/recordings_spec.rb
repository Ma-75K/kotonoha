require 'rails_helper'

RSpec.describe "Recordings", type: :request do
  let(:user) { create(:user, password: "password", password_confirmation: "password") }
  let!(:child) { create(:child, user: user, name: "さき") }

  before do
    post login_path, params: {
      email: user.email,
      password: "password"
    }
  end

  describe "GET /children/:child_id/recordings" do
    it "一覧画面が表示できる" do
      get child_recordings_path(child)

      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /children/:child_id/recordings/:id" do
    let!(:recording) { create(:recording, child: child, user: user) }

    it "詳細画面が表示できる" do
      get child_recording_path(child, recording)

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /children/:child_id/recordings" do
    let(:audio_file) do
      fixture_file_upload(Rails.root.join("spec/fixtures/files/sample.mp3"), "audio/mpeg")
    end

    it "録音保存に成功する" do
      expect {
        post child_recordings_path(child), params: {
          recording: {
            duration: 10,
            audio: audio_file
          }
        }
      }.to change(Recording, :count).by(1)

      expect(response).to have_http_status(:success)
    end
  end

  describe "POST /children/:child_id/recordings" do
    let(:audio_file) do
      fixture_file_upload(Rails.root.join("spec/fixtures/files/sample.mp3"), "audio/mpeg")
    end

    it "バリデーションエラーで保存に失敗する" do
      expect {
        post child_recordings_path(child), params: {
          recording: {
            title: "テスト録音",
            duration: 0,
            audio: audio_file
          }
        }
      }.not_to change(Recording, :count)

      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe "PATCH /children/:child_id/recordings/:id" do
    let!(:recording) { create(:recording, child: child, user: user, title: "変更前タイトル") }

    it "編集更新ができる" do
      patch child_recording_path(child, recording), params: {
        recording: {
          title: "変更後タイトル"
        }
      }

      expect(response).to redirect_to(child_recording_path(child, recording))
      expect(recording.reload.title).to eq("変更後タイトル")
    end
  end

  describe "DELETE /children/:child_id/recordings/:id" do
    let!(:recording) { create(:recording, child: child, user: user) }

    it "削除ができる" do
      expect {
        delete child_recording_path(child, recording)
      }.to change(Recording, :count).by(-1)

      expect(response).to redirect_to(child_recordings_path(child))
    end
  end
end
