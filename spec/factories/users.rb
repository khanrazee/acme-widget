FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user#{n}@example.com" }
    password { 'password123' }
    password_confirmation { 'password123' }
    role { 'customer' }
    
    trait :admin do
      role { 'admin' }
    end
    
    trait :customer do
      role { 'customer' }
    end
  end
end
