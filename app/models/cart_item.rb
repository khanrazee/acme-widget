class CartItem < ApplicationRecord
  include CartItemConcerns

  belongs_to :product
  belongs_to :cart

  validates :quantity, presence: true, numericality: { greater_than: 0, less_than_or_equal_to: 15 }
  validates :price_cents, presence: true, numericality: { greater_than: 0 }
  validates :price, presence: true, numericality: { greater_than: 0 }
end
