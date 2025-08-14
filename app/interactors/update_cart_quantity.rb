class UpdateCartQuantity
  include Interactor

  def call
    product = context.product
    cart = context.cart
    quantity = context.quantity || 0

    cart_item = cart.cart_items.find_by(product_id: product.id)
    if quantity.positive?
      if cart_item
        cart_item.quantity = quantity
      else
        cart_item = cart.cart_items.build(
          product_id: product.id,
          price_cents: product.price,
          quantity: quantity
        )
      end

      context.fail!(message: 'Failed to update cart quantity') unless cart_item.save
    else
      cart_item&.destroy
    end

    context.product = product
  end
end
