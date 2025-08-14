module CartConcerns
  extend ActiveSupport::Concern

  def add_product(product, quantity = 1)
    current_item = cart_items.find_by(product_id: product.id)

    if current_item
      current_item.quantity += quantity
    else
      current_item = cart_items.build(product_id: product.id, price_cents: product.price,
                                    quantity: quantity)
    end

    current_item
  end

  def remove_product(product)
    cart_items.where(product_id: product.id).destroy_all
  end

  def total_price_cents
    cart_items.sum(&:total_price_cents)
  end

  def total_price_in_currency
    total_price_cents / 100.0
  end

  def subtotal
    total_price_cents
  end
  
  def total_savings_amount
    cart_items.sum(&:savings_amount)
  end
  
  def total_savings_in_currency
    total_savings_amount / 100.0
  end
end
