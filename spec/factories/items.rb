FactoryBot.define do
  factory :item do
    user
    sequence(:name) { |n| "Item #{n}" }
    weight { rand(1..1000) } # ランダムな重さを設定

     # Packモデルの作成
     transient do
      packs_count { 0 }
    end

    after(:build) do |item, evaluator|
      evaluator.packs_count.times do
        item.pack_items << FactoryBot.build(:pack_item, item: item, pack: create(:pack))
      end
    end
  end
end
