FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "primary#{n}@example.com" }
    password { "000000" }
    name { "テスト太郎" }
    introduction { "" }
    target_time { "" }
    image_id { "" }
    user_status { 0 }
    confirmed_at { DateTime.now }
  end
end
