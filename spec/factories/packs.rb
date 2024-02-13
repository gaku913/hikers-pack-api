FactoryBot.define do
  factory :pack do
    association :user
    sequence(:title) { |n| "Title(#{n})" }
    memo { "this is memo."}
    start_date { Faker::Date.between(from: 1.year.ago, to: Date.today) }
    end_date { start_date + Faker::Number.between(from: 1, to: 10).days }
  end
end
