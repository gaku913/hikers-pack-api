FactoryBot.define do
  factory :user, traits: [:with_packs] do
    name { "test_user" }
    sequence(:email) { |n| "test#{n}@exmple.com" }
    password { "password" }
    password_confirmation { "password" }

    # packsを関連付ける
    trait :with_packs do
      transient do
        packs_count { 0 }
      end

      after(:build) do |user, evaluator|
        evaluator.packs_count.times do
          user.packs << FactoryBot.build(:pack, user: user)
        end
      end
    end
  end
end
