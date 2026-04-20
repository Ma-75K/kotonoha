require "rails_helper"

RSpec.describe "OnThisDay", type: :request do
  let(:user) { create(:user, password: "password", password_confirmation: "password") }
  let!(:child) { create(:child, user: user, name: "さき") }
  let!(:other_child) { create(:child, user: user, name: "みなと") }

  before do
    allow(Date).to receive(:current).and_return(Date.new(2025, 4, 20))

    post login_path, params: {
      email: user.email,
      password: "password"
    }
  end

  let!(:target_recording) do
    create(:recording, child: child, user: user, title: "一年前の今日の録音", recorded_at: Time.zone.parse("2024-04-20 10:00:00"))
  end

  let!(:old_recording) do
    create(:recording, child: child, user: user, title: "二年前の録音", recorded_at: Time.zone.parse("2023-04-20 10:00:00"))
  end

  let!(:before_day_recording) do
    create(:recording, child: child, user: user, title: "前日の録音", recorded_at: Time.zone.parse("2024-04-19 10:00:00"))
  end

  let!(:next_day_recording) do
    create(:recording, child: child, user: user, title: "翌日の録音", recorded_at: Time.zone.parse("2024-04-21 10:00:00"))
  end

  let!(:other_child_recording) do
    create(:recording, child: other_child, user: user, title: "別の子どもの録音", recorded_at: Time.zone.parse("2024-04-20 10:00:00"))
  end

  describe "GTE /children/:child_id/recordings/on_this_day" do
    it "画面が正常に表示される" do
      get on_this_day_child_recordings_path(child)

      expect(response).to have_http_status(:success)
    end

    it "一年前の同日の録音だけが表示される" do
      get on_this_day_child_recordings_path(child)

      expect(response.body).to include("一年前の今日の録音")
      expect(response.body).not_to include("二年前の録音")
      expect(response.body).not_to include("前日の録音")
      expect(response.body).not_to include("翌日の録音")
    end

    it "別の子どもの録音は表示されない" do
      get on_this_day_child_recordings_path(child)

      expect(response.body).to include("一年前の今日の録音")
      expect(response.body).not_to include("別の子どもの録音")
    end
  end

  context "該当する録音がない場合" do
    it "画面は正常に表示される" do
      Recording.delete_all

      get on_this_day_child_recordings_path(child)

      expect(response).to have_http_status(:success)
    end
  end
end
