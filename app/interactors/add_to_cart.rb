class AddToCart
  include Interactor

  def call
    product = context.product
    cart = context.cart
    quantity = context.quantity || 1

    if quantity < 1
      context.fail!(message: 'Quantity must be at least 1')
      return
    end

    cart_item = cart.add_product(product, quantity)

    unless cart_item.save
      context.fail!(message: 'There was a problem adding the item to your cart.')
    end

    context.cart_item = cart_item
    context.product = product
  end
end
