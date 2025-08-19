module OrderConcerns
  extend ActiveSupport::Concern

  def add_items_from_cart(cart)
    cart.cart_items.each do |cart_item|
      order_line_items << OrderLineItem.from_cart_item(cart_item)
    end
    calculate_total
  end

  def total_price_in_currency
    total_cents / 100.0
  end

  def calculate_total
    self.total_cents = order_line_items.sum(&:total_price_cents)
  end

  module ClassMethods
    def from_cart(cart, user)
      order = user.orders.create
      order.add_items_from_cart(cart)
      order.save
      order
    end
  end
end
