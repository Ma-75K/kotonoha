require 'rails_helper'

RSpec.describe Child, type: :model do
  describe "バリデーション" do
    it "name、birthday、user があれば有効" do
      child = build(:child)
      expect(child).to be_valid
    end

    it "name がない場合は無効" do
      child = build(:child, name: nil)
      expect(child).to be_invalid
      expect(child.errors[:name]).to include("を入力してください")
    end

    it "birthday がない場合は無効" do
      child = build(:child, birthday: nil)
      expect(child).to be_invalid
      expect(child.errors[:birthday]).to include("を入力してください")
    end

    it "user に紐付いていること" do
      child = build(:child)
      expect(child.user).to be_present
    end
  end
end
