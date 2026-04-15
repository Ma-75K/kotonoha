FactoryBot.define do
  factory :child do
    association :user
    name { "ことちゃん" }
    birthday { Date.new(2022, 7, 28) }
  end
end
