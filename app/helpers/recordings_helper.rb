module RecordingsHelper
  def format_duration(seconds)
    return "00:00" if seconds.blank?

    minutes = seconds / 60
    remaining_seconds = seconds % 60

    format("%02d:%02d", minutes, remaining_seconds)
  end
end
