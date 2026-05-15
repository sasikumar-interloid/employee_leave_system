FactoryBot.define do
  factory :user do
    email { "test#{rand(1000)}@example.com" }
    password { "Password1!" }
    password_confirmation { "Password1!" }

    trait :remembered do
      remember_created_at { Time.current }
    end

    trait :locked do
      failed_attempts { 5 }
      locked_at { Time.current }
      unlock_token { Devise.friendly_token }
    end
  end
end