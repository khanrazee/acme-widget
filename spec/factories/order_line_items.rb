FactoryBot.define do
  factory :order_line_item do
    association :product
    association :order
    quantity { 1 }
    price { 19.95 }
  end
end
