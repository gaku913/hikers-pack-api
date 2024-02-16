FactoryBot.define do
  factory :user do
    name { "test_user" }
    sequence(:email) { |n| "test#{n}@exmple.com" }
    password { "password" }
    password_confirmation { "password" }

    # packs, itemsを関連付ける
    transient do
      packs_count { 0 }
      items_count { 0 }
    end

    after(:build) do |user, evaluator|
      evaluator.packs_count.times do
        user.packs << FactoryBot.build(:pack, user: user)
      end
      evaluator.items_count.times do
        user.items << FactoryBot.build(:item, user: user)
      end
    end
  end
end
