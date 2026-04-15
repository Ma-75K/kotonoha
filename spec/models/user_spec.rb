require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    it "factoryが有効であること" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "name がない場合は無効" do
      user = build(:user, name: nil)
      expect(user).to be_invalid
      expect(user.errors[:name]).to be_present
    end

    it "email がない場合は無効" do
      user = build(:user, email: nil)
      expect(user).to be_invalid
      expect(user.errors[:email]).to be_present
    end

    it "email が重複している場合は無効" do
      create(:user, email: "test@example.com")
      user = build(:user, email: "test@example.com")

      expect(user).to be_invalid
      expect(user.errors[:email]).to be_present
    end

    it "password がない場合は無効" do
      user = build(:user, password: nil, password_confirmation: nil)
      expect(user).to be_invalid
      expect(user.errors[:password]).to be_present
    end

    it "password_confirmation がない場合は無効" do
      user = build(:user, password_confirmation: nil)
      expect(user).to be_invalid
      expect(user.errors[:password_confirmation]).to be_present
    end

    it "password と password_confirmation が一致しない場合は無効" do
      user = build(:user, password: "password", password_confirmation: "different")
      expect(user).to be_invalid
      expect(user.errors[:password_confirmation]).to be_present
    end

    it "password が3文字未満の場合は無効" do
      user = build(:user, password: "ab", password_confirmation: "ab")
      expect(user).to be_invalid
      expect(user.errors[:password]).to be_present
    end
  end
end
