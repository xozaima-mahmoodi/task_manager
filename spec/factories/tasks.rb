FactoryBot.define do
  factory :task do
    completed { false }
    title { Faker::Lorem.sentence(word_count: 3) }
  end
end
