class Product < ApplicationRecord
  include ProductConcerns

  has_many :cart_items, dependent: :destroy
  has_many :order_line_items, dependent: :destroy

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :special_offer, inclusion: { in: [true, false] }

  attr_accessor :price_in_currency

  def price_in_currency
    price ? (price / 100.0) : nil
  end
end
