module CartsHelper
  def calculate_delivery_fee(subtotal_cents)
    if subtotal_cents < 5000
      495
    elsif subtotal_cents < 9000
      295
    else
      0
    end
  end

  def calculate_total_with_delivery(subtotal_cents)
    subtotal_cents + calculate_delivery_fee(subtotal_cents)
  end

  def format_price(cents)
    number_to_currency(cents / 100.0)
  end
end
