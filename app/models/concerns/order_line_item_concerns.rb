module OrderLineItemConcerns
  extend ActiveSupport::Concern
  include ItemPricing

  module ClassMethods
    def from_cart_item(cart_item)
      new(
        product: cart_item.product,
        quantity: cart_item.quantity,
        price: cart_item.price
      )
    end
  end
end
