FactoryBot.define do
  factory :recording do
    user { nil }
    child { nil }
    title { "MyString" }
    comment { "MyText" }
    recorded_at { "2026-02-27 12:25:25" }
    duration { 1 }
  end
end
