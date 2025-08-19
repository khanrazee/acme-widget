FactoryBot.define do
  factory :cart_item do
    association :product
    association :cart
    quantity { 1 }
    price { 19.95 }
  end
end
