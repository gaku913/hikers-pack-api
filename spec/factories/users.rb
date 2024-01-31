FactoryBot.define do
  factory :user do
    name { "test_user" }
    sequence(:email) { |n| "test#{n}@exmple.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
