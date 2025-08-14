FactoryBot.define do
  factory :order do
    association :user
    status { 'pending' }
    total_cents { 1 }
  end
end
