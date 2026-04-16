FactoryBot.define do
  factory :recording do
    association :child
    user { child.user }
    title { "はじめてのことば" }
    recorded_at { Time.current }
    duration { 10 }

    after(:build) do |recording|
      recording.audio.attach(
        io: File.open(Rails.root.join("spec/fixtures/files/sample.mp3")),
        filename: "sample.mp3",
        content_type: "audio/mpeg"
      )
    end
  end
end
