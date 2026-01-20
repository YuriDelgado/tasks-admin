FactoryBot.define do
  factory :user do
    email { "user#{SecureRandom.hex(4)}@example.com" }
    password { "123456" }
  end
end
