FactoryBot.define do
  factory :product do
    sequence(:code) { |n| "PROD#{n}" }
    sequence(:name) { |n| "Product #{n}" }
    price { 1995 } # $19.95 in cents
  end
end
