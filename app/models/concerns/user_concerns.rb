module UserConcerns
  extend ActiveSupport::Concern

  def current_cart
    cart || create_cart
  end

  def checkout_cart
    return nil unless cart
    return nil if cart.cart_items.empty?

    Order.from_cart(cart, self)
  end

  def admin?
    role == 'admin'
  end

  def customer?
    role == 'customer'
  end
end
