require 'rails_helper'

RSpec.describe ChildDecorator do
  describe "#age_at" do
    it "指定日時点の年齢を『〇歳〇か月』で返す" do
      child = build(:child, birthday: Date.new(2022, 7, 28)).decorate

      expect(child.age_at(Date.new(2024, 10, 1))).to eq("2歳2か月")
    end

    it "birthday がない場合は nil を返す" do
      child = build(:child, birthday: nil).decorate
      expect(child.age_at(Date.new(2024, 10, 1))).to be_nil
    end

    it "target_date がない場合は nil を返す" do
      child = build(:child, birthday: Date.new(2022, 7, 28)).decorate
      expect(child.age_at(nil)).to be_nil
    end

    it "誕生日前の日付を指定した場合は nil を返す" do
      child = build(:child, birthday: Date.new(2022, 7, 28)).decorate
      expect(child.age_at(Date.new(2022, 7, 27))).to be_nil
    end

    it "誕生日当日はちょうど次の年齢になる" do
      child = build(:child, birthday: Date.new(2022, 7, 28)).decorate
      expect(child.age_at(Date.new(2023, 7, 28))).to eq("1歳0か月")
    end

    it "誕生日の前日はまだ次の年齢にならない" do
      child = build(:child, birthday: Date.new(2022, 7, 28)).decorate
      expect(child.age_at(Date.new(2023, 7, 27))).to eq("0歳11か月")
    end

    it "誕生日の日に達していない場合は月齢が増えない" do
      child = build(:child, birthday: Date.new(2022, 7, 28)).decorate
      expect(child.age_at(Date.new(2022, 8, 27))).to eq("0歳0か月")
    end

    it "誕生日の日を過ぎていれば月齢が増える" do
      child = build(:child, birthday: Date.new(2022, 7, 28)).decorate
      expect(child.age_at(Date.new(2022, 8, 29))).to eq("0歳1か月")
    end
  end

  describe "#current_age" do
    it "今日時点の年齢を『〇歳〇か月』で返す" do
      child = build(:child, birthday: Date.new(2022, 7, 28)).decorate

      allow(Date).to receive(:current).and_return(Date.new(2024, 10, 1))
      expect(child.current_age).to eq("2歳2か月")
    end
  end
end
