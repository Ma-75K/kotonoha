class Recording < ApplicationRecord
  belongs_to :user
  belongs_to :child

  has_one_attached :audio, dependent: :purge_later
  before_validation :set_recorded_at, on: :create

  validates :title, presence: true
  validates :recorded_at, presence: true
  validates :duration, presence: true, numericality: { greater_than: 0 }

  validate :audio_file_format

  private

  def set_recorded_at
    self.recorded_at ||= Time.current
  end

  def audio_file_format
    unless audio.attached?
      errors.add(:audio, "を添付してください")
      return
    end

    acceptable_types = [ "audio/webm", "audio/wav", "audio/mpeg", "audio/mp4", "audio/ogg" ]
    unless acceptable_types.include?(audio.content_type)
      errors.add(:audio, "は音声ファイルである必要があります")
    end

    max_size = 50.megabytes
    if audio.byte_size > max_size
      errors.add(:audio, "は50MG以下である必要があります")
    end
  end
end
