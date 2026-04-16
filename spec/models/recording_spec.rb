require 'rails_helper'

RSpec.describe Recording, type: :model do
  describe "バリデーション" do
    it "factoryが有効であること" do
      recording = build(:recording)
      expect(recording).to be_valid
    end

    it "title がない場合は無効" do
      recording = build(:recording, title: nil)
      expect(recording).to be_invalid
      expect(recording.errors[:title]).to be_present
    end

    it "duration がない場合は無効" do
      recording = build(:recording, duration: nil)
      expect(recording).to be_invalid
      expect(recording.errors[:duration]).to be_present
    end

    it "duration が 0 の場合は無効" do
      recording = build(:recording, duration: 0)
      expect(recording).to be_invalid
      expect(recording.errors[:duration]).to be_present
    end

    it "duration がマイナスの場合は無効" do
      recording = build(:recording, duration: -1)
      expect(recording).to be_invalid
      expect(recording.errors[:duration]).to be_present
    end

    it "recorded_at が nil でも作成時に自動生成される" do
      recording = build(:recording, recorded_at: nil)
      recording.valid?
      expect(recording.recorded_at).to be_present
    end

    it "audio がある場合は有効" do
      recording = build(:recording)
      expect(recording.audio).to be_attached
      expect(recording).to be_valid
    end

    it "audio がない場合は無効" do
      recording = build(:recording)
      recording.audio.detach

      expect(recording).to be_invalid
      expect(recording.errors[:audio]).to be_present
    end

    it "許可された content_type の場合は有効" do
      recording = build(:recording)
      recording.audio.detach

      recording.audio.attach(
        io: File.open(Rails.root.join("spec/fixtures/files/sample.mp3")),
        filename: "sample.mp3",
        content_type: "audio/mpeg"
      )

      expect(recording).to be_valid
    end

    it "許可されていない content_type の場合は無効" do
      recording = build(:recording)
      recording.audio.detach

      recording.audio.attach(
        io: StringIO.new("dummy test"),
        filename: "sample.txt",
        content_type: "text/plain"
      )

      expect(recording).to be_invalid
      expect(recording.errors[:audio]).to be_present
    end

    it "サイズ制限を超える場合は無効" do
      recording = build(:recording)
      recording.audio.detach

      large_file = Tempfile.new([ "large", ".mp3" ])
      large_file.binmode
      large_file.write("a" * (51.megabytes))
      large_file.rewind

      recording.audio.attach(
        io: large_file,
        filename: "large.mp3",
        content_type: "audio/mpeg"
      )

      expect(recording).to be_invalid
      expect(recording.errors[:audio]).to be_present

      large_file.close
      large_file.unlink
    end

    it "user に紐付いていること" do
      recording = build(:recording)
      expect(recording.user).to be_present
    end

    it "child に紐付いていること" do
      recording = build(:recording)
      expect(recording.child).to be_present
    end
  end
end
