class CreateOrderFromCart
  include Interactor

  def call
    cart = context.cart
    user = context.user

    if cart.nil? || cart.cart_items.empty?
      context.fail!(message: 'Your cart is empty.')
      return
    end

    order = user.orders.build

    delivery_fee = calculate_delivery_fee(cart.total_price_cents)

    order.add_items_from_cart(cart)

    order.update(delivery_fee_cents: delivery_fee)
    order.total_cents += delivery_fee

    if order.save
      order.update(status: :completed)
      cart.cart_items.destroy_all
      context.order = order
    else
      context.fail!(message: 'There was a problem creating your order.')
    end
  end

  private

  def calculate_delivery_fee(total_cents)
    if total_cents < 5000
      495
    elsif total_cents < 9000
      295
    else
      0
    end
  end
end
