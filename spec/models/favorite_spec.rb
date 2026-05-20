require 'rails_helper'

RSpec.describe Favorite, type: :model do
  describe "バリデーション" do
    it "user と recording があれば有効" do
      favorite = build(:favorite)

      expect(favorite).to be_valid
    end

    it "同じユーザーが同じ録音を重複してお気に入りできない" do
      user = create(:user)
      recording = create(:recording)

      create(:favorite, user: user, recording: recording)
      favorite = build(:favorite, user: user, recording: recording)

      expect(favorite).to be_invalid
    end
  end
end
