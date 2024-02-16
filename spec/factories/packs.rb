FactoryBot.define do
  factory :pack do
    user
    sequence(:title) { |n| "Title(#{n})" }
    memo { "this is memo."}
    start_date { Faker::Date.between(from: 1.year.ago, to: Date.today) }
    end_date { start_date + Faker::Number.between(from: 1, to: 10).days }

    # Itemモデルの作成
    transient do
      items_count { 0 }
    end

    after(:build) do |pack, evaluator|
      evaluator.items_count.times do
        pack.pack_items << FactoryBot.build(:pack_item, pack: pack, item: build(:item))
      end
    end
  end
end
