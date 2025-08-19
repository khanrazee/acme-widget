class UpdateCart
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

      unless cart_item.save
        context.fail!(message: 'Failed to update cart')
        return
      end
      
      context.product = product
      context.cart_item = cart_item
      context.is_new_item = cart_item.previous_changes.key?('id')
    else
      if cart_item
        cart_item.destroy
      else
        context.fail!(message: 'Product not found in cart')
      end
    end
  end
end
