FactoryBot.define do
  factory :order do
    association :user
    status { 'pending' }
    total_cents { 1999 }

    to_create { |instance| instance.save(validate: false) }
    
    trait :with_items do
      after(:create) do |order|
        create(:order_line_item, order: order)
      end
    end
  end
end
