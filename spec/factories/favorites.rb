FactoryBot.define do
  factory :favorite do
    association :user
    association :recording
  end
end
